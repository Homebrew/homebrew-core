class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/47/f4/fc774e32fb48febd5297141bd85081dc55d36da69937fcc9abb168c8ffe2/pipenv-2022.9.4.tar.gz"
  sha256 "923a1c06ff70b1486ad6e7bd8279dfb3c599f560b0e392e5b7a98dfafa97115f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abac893d88477d62d76bd31757226e7a9682d2dcf6cf2da0f2af1aa29ab21ffc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64be5e76c66cc8f4949fba7d2dcc3bcff114da4a86865c0306866cceb1d007c7"
    sha256 cellar: :any_skip_relocation, monterey:       "a941160a15bdfa6e9bca7a8270abcad235045c41f8567c765ffa44c94493addc"
    sha256 cellar: :any_skip_relocation, big_sur:        "d496273d6590750f4ad4562d76b98baffd41c175dd7ade415fac361913e136a1"
    sha256 cellar: :any_skip_relocation, catalina:       "1a7084f96850128ac00b4eba68d728cd45e42febaa55c189ef7d2013f5625619"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4e3a88d632e884cda2d95a54c2df509fa325875a7a945ac8a5d9fe695a0df53"
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
    system "#{bin}/pipenv", "--python", Formula["python@3.10"].opt_bin/"python3"
    system "#{bin}/pipenv", "install", "requests"
    system "#{bin}/pipenv", "install", "boto3"
    assert_predicate testpath/"Pipfile", :exist?
    assert_predicate testpath/"Pipfile.lock", :exist?
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
