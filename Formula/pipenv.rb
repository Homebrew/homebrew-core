class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/ec/66/8e08203170453505c761f30bfbfb085fc236bbf949f1012c8b095259a3eb/pipenv-2022.10.25.tar.gz"
  sha256 "3e39c8d5a2bcaab324552a18576105c2a35e020bb311ff53d74eacb58b851853"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5280ec6f458b24f94400d50027f13c0eaa6c793109c0f9572bc48bb06363c03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eecd0507589ec2fb3a4f00c8a2bf048232cf4c1dc8be27d9cd3bc765ee14c84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9b8a6653d2a901536862d14ed1f30237752c48933b70f54c32c2dbc504d19ce"
    sha256 cellar: :any_skip_relocation, monterey:       "020487cdaa75152b1a79d3701f46c2c2bfc9aab381e02bf1835a2e781b04c675"
    sha256 cellar: :any_skip_relocation, big_sur:        "019ea2fa3e716e80835e2507fa7e99f141ac08c888af9de02bd8b698a1070059"
    sha256 cellar: :any_skip_relocation, catalina:       "9d4c5e7e26e711a69f9df02de732a7f864aa2b324d22991652eb7c231a625c4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce176e29724630bfe6ee13fc61065d40d89f2581cbd8ce47e0d95e97098033e2"
  end

  depends_on "python@3.10"
  depends_on "six"

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
    "python3.10"
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
