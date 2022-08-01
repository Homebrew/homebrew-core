class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/e4/2a/2105cf9ff5bface220d3b6e0e82e38a5b3864fc2b444f90d908b1d12f748/pipenv-2022.7.24.tar.gz"
  sha256 "374e63450220d7abb298cbaee06c4b02274e6f1cb2ce7b7b677fd5fd3dd30841"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea2ab6366349ea01dfb119a12ad54b3500f530dd56f7862a57eb4c7354b06cd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd7a556ecf8c8a4a9ce37f7141a227847047c22f045dd08096f8bba0804e8cf1"
    sha256 cellar: :any_skip_relocation, monterey:       "514ded441332a5c6fccb17d057517cfb5bb3f7d98632132768bebb7e037e7449"
    sha256 cellar: :any_skip_relocation, big_sur:        "c59729702a35eba37d5dd4f3d02bd673bcf14c58f1431369cb3483f2ef5eea65"
    sha256 cellar: :any_skip_relocation, catalina:       "087c4ade9fbfa14f969fd77152aa68d760d7c4b8560e8d6dd7fda31012e7b715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f726649905e0d3ddbcd79edf12923eab8973e3e234fb4eb2faac371758e5892"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/31/d5/e2aa0aa3918c8d88c4c8e4ebbc50a840e101474b98cd83d3c1712ffe5bb4/distlib-0.3.5.tar.gz"
    sha256 "a7f75737c70be3b25e2bee06288cec4e4c221de18455b2dd037fe2a795cab2fe"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/f3/c7/5c1aef87f1197d2134a096c0264890969213c9cbfb8a4102087e8d758b5c/filelock-3.7.1.tar.gz"
    sha256 "3a0fd85166ad9dbab54c9aec96737b744106dc5f15c0b09a6744a445299fcf04"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/a4/2f/05b77cb73501c01963de2cef343839f0803b64aab4d5476771ae303b97a6/virtualenv-20.15.1.tar.gz"
    sha256 "288171134a2ff3bfb1a2f54f119e77cd1b81c29fc1265a2356f3e8d14c7d58c4"
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
