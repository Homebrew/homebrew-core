class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/f0/97/d0180bd79b1e5017c67baa4b9644d43b10e43448dc0e068e3ed0f629f979/pipenv-2022.8.14.tar.gz"
  sha256 "220f1863ee3d67fe073d7d14dfad3a0cd9dafe1bce4c7970da6ad16467d12f06"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0895cf672661a56e09d5eee190c63bfdeee76fc9c8b473089a19a3ab6eadd0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d82001831d6cf157f89602dd05c59bfe6a841288057f277df5f9b54ceb46d3c3"
    sha256 cellar: :any_skip_relocation, monterey:       "359713560aeae0b6750c269246ed1aa80a94faf5606c6aadc85155a34269ef92"
    sha256 cellar: :any_skip_relocation, big_sur:        "d79c4b1d78083f6ea9e268ca4fec2845ac0744aafe8ce8ccae331f1b2efc34bb"
    sha256 cellar: :any_skip_relocation, catalina:       "ce386efb2b9ad127b14a424bf7a2ba5045710ee8d401c2c20e73c7f0d1bc05f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24f8d7466d5e2b379bcf12670e77f599a3d66556dccbab8bf3eda7551514e290"
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
    url "https://files.pythonhosted.org/packages/95/55/b897882bffb8213456363e646bf9e9fa704ffda5a7d140edf935a9e02c7b/filelock-3.8.0.tar.gz"
    sha256 "55447caa666f2198c5b6b13a26d2084d26fa5b115c00d065664b2124680c4edc"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/3c/ea/a39a173e7943a8f001e1f97326f88e1535b945a3aec31130c3029dce19df/virtualenv-20.16.3.tar.gz"
    sha256 "d86ea0bb50e06252d79e6c241507cb904fcd66090c3271381372d6221a3970f9"
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
