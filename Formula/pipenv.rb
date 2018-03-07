class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://docs.pipenv.org/"
  url "https://files.pythonhosted.org/packages/f1/b5/b6d5fe8b38a813853d036a889ae98b264fd872be7cc47b390a098879f285/pipenv-11.1.3.tar.gz"
  sha256 "1d1326d4c54726e9288cac8023b51f7efca50a1319138a72d119554201f27394"

  bottle do
    cellar :any_skip_relocation
    sha256 "8537c55e7f22dc0786124e3f28035d374926984136b72aabc06476ba817399f7" => :high_sierra
    sha256 "4b017bf9d3bca8a1e64446aa651296e7659d19292557f7d440928af87b6642d2" => :sierra
    sha256 "ffddb97da52b086a309694e15a380b9fe913e6277b3933566d43ce0cac3a5726" => :el_capitan
  end

  depends_on "python"

  resource "pew" do
    url "https://files.pythonhosted.org/packages/21/8c/585c136d5c63eb80ece3328eb290d16ccf6d2d55420848d9fc6a07de68ca/pew-1.1.2.tar.gz"
    sha256 "b8312728526c9010295c88215c95a1b1731fdbd1a568f728e069932bd0545611"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d4/0c/9840c08189e030873387a73b90ada981885010dd9aea134d6de30cd24cb8/virtualenv-15.1.0.tar.gz"
    sha256 "02f8102c2436bb03b3ee6dede1919d1dac8a427541652e5ec95171ec8adbc93a"
  end

  resource "virtualenv-clone" do
    url "https://files.pythonhosted.org/packages/14/2f/84b6a8e380439cdfdb71e0ced2a805a66e343ac540d3304bde6bc28fbb46/virtualenv-clone-0.3.0.tar.gz"
    sha256 "b5cfe535d14dc68dfc1d1bb4ac1209ea28235b91156e2bba8e250d291c3fb4f8"
  end

  def install
    # Using the virtualenv DSL here because the alternative of using
    # write_env_script to set a PYTHONPATH breaks things.
    # https://github.com/Homebrew/homebrew-core/pull/19060#issuecomment-338397417
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    venv.pip_install buildpath

    # `pipenv` needs to be able to find `virtualenv` and `pew` on PATH. So we
    # install symlinks for those scripts in `#{libexec}/tools` and create a
    # wrapper script for `pipenv` which adds `#{libexec}/tools` to PATH.
    (libexec/"tools").install_symlink libexec/"bin/pew", libexec/"bin/pip",
                                      libexec/"bin/virtualenv"
    env = {
      :PATH => "#{libexec}/tools:$PATH",
    }
    (bin/"pipenv").write_env_script(libexec/"bin/pipenv", env)
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?
      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
    inreplace lib_python_path/"orig-prefix.txt",
              Formula["python3"].opt_prefix, Formula["python3"].prefix.realpath
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "Commands", shell_output("#{bin}/pipenv")
    system "#{bin}/pipenv", "install", "requests"
    assert_predicate testpath/"Pipfile", :exist?
    assert_predicate testpath/"Pipfile.lock", :exist?
    assert_match "requests", (testpath/"Pipfile").read
  end
end
