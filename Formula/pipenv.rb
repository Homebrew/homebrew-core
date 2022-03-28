class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/1a/c1/c50830f214d247fc1fb349d72ca72773e02021494d4d3a28d631edac1d33/pipenv-2022.3.28.tar.gz"
  sha256 "4e7aae62dad7679ce81b54cc3451be19fb2c469e269335b36b14132fe5ceecb3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a232e4fb3abc7a6fd22a096299938c2fc1fa713412375ac91c3e2f07ec37994"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5140eb5150cf50dbdb486044da234f7e2bfe72d223a12c88b8a86785e03827b6"
    sha256 cellar: :any_skip_relocation, monterey:       "41435350f56151ec5192aa62531934088d417b511e7d94cc28c4140066abe0e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbd8cfffd40271afd68945a5822f6258c78b32ad1d59ae9107a7c13231405b33"
    sha256 cellar: :any_skip_relocation, catalina:       "f6e69c67b41e0f640c6882e00bb7986f0016a7570eecf2d8d5836d207a300073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9188f15d249a6fe2b8c326e50bba20496eeaf22161e8a941297fb23fccac3d89"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/85/01/88529c93e41607f1a78c1e4b346b24c74ee43d2f41cfe33ecd2e20e0c7e3/distlib-0.3.4.zip"
    sha256 "e4b58818180336dc9c529bfb9a0b58728ffc09ad92027a3f30b7cd91e3458579"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/4d/cd/3b1244a19d61c4cf5bd65966eef97e6bc41e51fe84110916f26554d6ac8c/filelock-3.6.0.tar.gz"
    sha256 "9cd540a9352e432c7246a48fe4e8712b10acb1df2ad1f30e8c070b82ae1fed85"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/33/66/61da40aa546141b0d70b37fe6bb4ef1200b4b4cb98849f131b58faa9a5d2/platformdirs-2.5.1.tar.gz"
    sha256 "7535e70dfa32e84d4b34996ea99c5e432fa29a708d0f4e394bbcb2a8faa4f16d"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/4a/c3/04f361a90ed4e6b3f3f696d61db5c786eaa741d2a6c125bc905b8a1c0200/virtualenv-20.14.0.tar.gz"
    sha256 "8e5b402037287126e81ccde9432b95a8be5b19d36584f64957060a3488c11ca8"
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
