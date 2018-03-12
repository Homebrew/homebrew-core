class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://docs.pipenv.org/"
  url "https://files.pythonhosted.org/packages/07/74/4cc0afcbbcbc4fa3322e5423059c1ed537cd95207a3159d82b4f3433390f/pipenv-11.6.1.tar.gz"
  sha256 "b4197346fc55faff13be24c50918c2660d272128f9265078879fb396bd2afd9c"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb449eac2ca59669382f6a9ff261f6b9f03b7cdc62c53f6ff17fcd3eb7ea9f9b" => :high_sierra
    sha256 "417f403bb6c22844892525132b00a0e1cecaf78a45577927786c9d938aa8307c" => :sierra
    sha256 "6d8ba65a0c8ab99d927a70c5dbf06d4c0135ced0f33ec28136fc5b1cdf5bb03e" => :el_capitan
  end

  depends_on "python"

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

    # `pipenv` needs to be able to find `virtualenv` and `pewtwo` on PATH. So we
    # install symlinks for those scripts in `#{libexec}/tools` and create a
    # wrapper script for `pipenv` which adds `#{libexec}/tools` to PATH.
    (libexec/"tools").install_symlink libexec/"bin/pewtwo", libexec/"bin/pip",
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
              Formula["python"].opt_prefix, Formula["python"].prefix.realpath
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
