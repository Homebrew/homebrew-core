class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/bb/37/71f25bc5af0b74d8e0f4e32793f26ceaee774fd06aa58533668a5ddedb6a/pipenv-2022.9.2.tar.gz"
  sha256 "10c0883edd1fd80aa29fd633df82683c24958e89778bf50c4673610bfb6dbfb0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4026a70b1d0906e8b48fa20d8e2e549a81fc4899e593886ed2d6400f733bf2ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "489ab92071fc9a2c4056ea646459aff33dcc703cd865771a7ba6f9ff0f032e64"
    sha256 cellar: :any_skip_relocation, monterey:       "f9ca429cb5a948ca313ae9919402fc5ce8ddc1d3610b7347d47ea3b5c6450d76"
    sha256 cellar: :any_skip_relocation, big_sur:        "d33a92ec196e40d6e28c995a7aabdec7b4b74f7c4ef29ad3dcaa9a709b95c2e2"
    sha256 cellar: :any_skip_relocation, catalina:       "7e16b279bc0ae1652737d1dd4273e484e43c2a94dced933d6f48d65f85eb2070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ff14f709d4cc3f84ca2fb196fb26dea7a06f7d3f0d87becc90e152f929d12e2"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
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
    url "https://files.pythonhosted.org/packages/62/2d/06980235e155c7ee1971f77439cbbc3069e98de49540e89f2291905eb4a8/virtualenv-20.16.4.tar.gz"
    sha256 "014f766e4134d0008dcaa1f95bafa0fb0f575795d07cae50b1bee514185d6782"
  end

  resource "virtualenv-clone" do
    url "https://files.pythonhosted.org/packages/85/76/49120db3bb8de4073ac199a08dc7f11255af8968e1e14038aee95043fafa/virtualenv-clone-0.5.7.tar.gz"
    sha256 "418ee935c36152f8f153c79824bb93eaf6f0f7984bae31d3f48f350b9183501a"
  end

  def install
    # Using the virtualenv DSL here because the alternative of using
    # write_env_script to set a PYTHONPATH breaks things.
    # https://github.com/Homebrew/homebrew-core/pull/19060#issuecomment-338397417
    venv = virtualenv_create(libexec, "python3")
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

    output = Utils.safe_popen_read(
      { "_PIPENV_COMPLETE" => "zsh_source" }, libexec/"bin/pipenv", { err: :err }
    )
    (zsh_completion/"_pipenv").write output

    output = Utils.safe_popen_read(
      { "_PIPENV_COMPLETE" => "fish_source" }, libexec/"bin/pipenv", { err: :err }
    )
    (fish_completion/"pipenv.fish").write output
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
    system "#{bin}/pipenv", "--python", Formula["python@3.10"].opt_bin/"python3"
    system "#{bin}/pipenv", "install", "requests"
    system "#{bin}/pipenv", "install", "boto3"
    assert_predicate testpath/"Pipfile", :exist?
    assert_predicate testpath/"Pipfile.lock", :exist?
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
