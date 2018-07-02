class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://docs.pipenv.org/"
  url "https://files.pythonhosted.org/packages/b3/98/8109e1b0488e3ad6b7bb1716842359827f337ddafa28275112bb76fc8477/pipenv-2018.7.1.tar.gz"
  sha256 "bb6bd074f853d9bab675942226a785a64d4fc42b5847538755e9573f5b77f63a"

  bottle do
    cellar :any_skip_relocation
    sha256 "60f024907a279b61665ea6c64836beece62a72375cf3d217b8d52d4f67aa1d03" => :high_sierra
    sha256 "0085107a2010e3fce5feb9fcbd8feb555809a68458e9e1abdfc4662154632fff" => :sierra
    sha256 "6816de1c639ea62e6b1a3752373559f427de2f69dab7a2bedf13a6b25d7e7bc9" => :el_capitan
  end

  depends_on "python"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/4d/9c/46e950a6f4d6b4be571ddcae21e7bc846fcbb88f1de3eff0f6dd0a6be55d/certifi-2018.4.16.tar.gz"
    sha256 "13e698f54293db9f89122b0581843a782ad0934a4fe0172d2a980ba77fc61bb7"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/33/bc/fa0b5347139cd9564f0d44ebd2b147ac97c36b2403943dbee8a25fd74012/virtualenv-16.0.0.tar.gz"
    sha256 "ca07b4c0b54e14a91af9f34d0919790b016923d157afda5efdde55c96718f752"
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

    output = Utils.popen_read("#{libexec}/bin/pipenv --completion")
    (bash_completion/"pipenv").write output
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
    system "#{bin}/pipenv", "install", "boto3"
    assert_predicate testpath/"Pipfile", :exist?
    assert_predicate testpath/"Pipfile.lock", :exist?
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
