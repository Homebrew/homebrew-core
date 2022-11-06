class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/74/4f/22ef1aace6d703a7b5bf80d09b8ca3315fd68bcba89bf2d625d8b330310b/pipenv-2022.9.24.tar.gz"
  sha256 "d682375d6a6edd2f1ed2f76085b7191de149ff8381bce6c1aaf7f55061b04457"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9e0188522aea35182fca9f51103bf49cf1439fe0f31631a10d3dfca7b0c5385"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "119592d5177383f1f35ee07101c675cf3be1e7dc52dd2bfd701094c91465a9f8"
    sha256 cellar: :any_skip_relocation, monterey:       "156ab2d9369892eae0c6431c5923b8e2030c316bb3e968f7373b7273b8458387"
    sha256 cellar: :any_skip_relocation, big_sur:        "31b1e64ebe2b1114cde1544c510bec64fd2bc63f929d2c707f70c9e5817201f1"
    sha256 cellar: :any_skip_relocation, catalina:       "01f5751634f437ece893b60070057cd8c5f263304a2c951f9fe98091da5c2a62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86aa3815e1aba46d70a1010eaa0638668e7285b2cd8f213a3afb1fe4c77a689e"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/95/55/b897882bffb8213456363e646bf9e9fa704ffda5a7d140edf935a9e02c7b/filelock-3.8.0.tar.gz"
    sha256 "55447caa666f2198c5b6b13a26d2084d26fa5b115c00d065664b2124680c4edc"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/b4/27/b71df0a723d879baa0af1ad897b2498ad78f284ae668b4420092e44c05fa/virtualenv-20.16.6.tar.gz"
    sha256 "530b850b523c6449406dfba859d6345e48ef19b8439606c5d74d7d3c9e14d76e"
  end

  resource "virtualenv-clone" do
    url "https://files.pythonhosted.org/packages/85/76/49120db3bb8de4073ac199a08dc7f11255af8968e1e14038aee95043fafa/virtualenv-clone-0.5.7.tar.gz"
    sha256 "418ee935c36152f8f153c79824bb93eaf6f0f7984bae31d3f48f350b9183501a"
  end

  def python3
    "python3.11"
  end

  def install
    # Using the virtualenv DSL here because the alternative of using
    # write_env_script to set a PYTHONPATH breaks things.
    # https://github.com/Homebrew/homebrew-core/pull/19060#issuecomment-338397417
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install buildpath

    # `pipenv` needs to be able to find `virtualenv` on PATH. So we
    # install symlinks for those scripts in `#{libexec}/tools` and create a
    # wrapper script for `pipenv` which adds `#{libexec}/tools` to PATH.
    (libexec/"tools").install_symlink libexec/"bin/pip", libexec/"bin/virtualenv"
    env = {
      PATH: "#{libexec}/tools:$PATH",
    }
    (bin/"pipenv").write_env_script(libexec/"bin/pipenv", env)

    (zsh_completion/"_pipenv").write Utils.safe_popen_read({ "_PIPENV_COMPLETE" => "zsh_source" },
                                                           libexec/"bin/pipenv", { err: :err })
    (fish_completion/"pipenv.fish").write Utils.safe_popen_read({ "_PIPENV_COMPLETE" => "fish_source" },
                                                                libexec/"bin/pipenv", { err: :err })
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
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "Commands", shell_output("#{bin}/pipenv")
    system "#{bin}/pipenv", "--python", which(python3)
    system "#{bin}/pipenv", "install", "requests"
    system "#{bin}/pipenv", "install", "boto3"
    assert_predicate testpath/"Pipfile", :exist?
    assert_predicate testpath/"Pipfile.lock", :exist?
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
