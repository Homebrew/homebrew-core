class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/f6/38/45d22be374034bc18720d60ba8e8b6e82242be492808df59d0abe5e5027e/pipenv-2021.11.9.tar.gz"
  sha256 "7662399162bc887ee86e96d0baa6984236228af9c1fd6594be0b18910225579d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e0626a322ae67a22f577ccfddc4fd568f9d3eb8378eb1c1faa68f6b3352abdd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad313f878cf10671754962f077eeb90b0a1c8d0acdec2513753fc48b19c61017"
    sha256 cellar: :any_skip_relocation, monterey:       "7cf3abe2b12a91d07e99da20d03095d66717732f3af670b9644228c5dd24f904"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c2c17225157ba5ded4484e51327548892dbab22532e993e277c3b85afbab70c"
    sha256 cellar: :any_skip_relocation, catalina:       "44fd41548a1ae7c63c610d3fdb3447e7191a761c86a62caf948457413120f21a"
    sha256 cellar: :any_skip_relocation, mojave:         "3996b20d3f9d8f869d876b2976bed9bbe325e8206cbffcdfbcd282cd024c671f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bda43e658fabc55db4fdde1ec6b048126b2aaadc0d98397396c73e5a6f4df9be"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "backports.entry-points-selectable" do
    url "https://files.pythonhosted.org/packages/e4/7e/249120b1ba54c70cf988a8eb8069af1a31fd29d42e3e05b9236a34533533/backports.entry_points_selectable-1.1.0.tar.gz"
    sha256 "988468260ec1c196dab6ae1149260e2f5472c9110334e5d51adcb77867361f6a"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/56/ed/9c876a62efda9901863e2cc8825a13a7fcbda75b4b498103a4286ab1653b/distlib-0.3.3.zip"
    sha256 "d982d0751ff6eaaab5e2ec8e691d949ee80eddf01a62eaa96ddb11531fe16b05"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/4f/c5/477ff63917e7670fe1f338a0226fbb1f654e4cbb2656f5c3ba81f5c26929/filelock-3.3.2.tar.gz"
    sha256 "7afc856f74fa7006a289fd10fa840e1eebd8bbff6bffb69c26c54a0512ea8cf8"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/4b/96/d70b9462671fbeaacba4639ff866fb4e9e558580853fc5d6e698d0371ad4/platformdirs-2.4.0.tar.gz"
    sha256 "367a5e80b3d04d2428ffa76d33f124cf11e8fff2acdaa9b43d545f5c7d661ef2"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/c7/3e/b11275c99dd779e4fc87931f7c82ce93767080249bfa4d7aea7ea748800e/virtualenv-20.10.0.tar.gz"
    sha256 "576d05b46eace16a9c348085f7d0dc8ef28713a2cabaa1cf0aea41e8f12c9218"
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
