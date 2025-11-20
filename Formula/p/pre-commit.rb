class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/a6/49/7845c2d7bf6474efd8e27905b51b11e6ce411708c91e829b93f324de9929/pre_commit-4.4.0.tar.gz"
  sha256 "f0233ebab440e9f17cabbb558706eb173d19ace965c68cdce2c081042b4fab15"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "84beef7286a41b6594cc63b37e5e8280608586a564b5b2a583e82c78da5f0fd7"
    sha256 cellar: :any,                 arm64_sequoia: "b847fcfcb05c1814510fc92dbf1ed837f8a77de8352e2ae551a083229508c980"
    sha256 cellar: :any,                 arm64_sonoma:  "f8657da3e7019d198498d05c8cae9dfe66461ae4aefed254098ed9a1286aa179"
    sha256 cellar: :any,                 sonoma:        "7242caf968d1545eeab363d2354d648927e185342ec469dbcffbb8d035706a47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bf7f69499faafd7860b470b81cb4f73ef3e7cf8b0b2f25b5d145b0b0b670c5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a866a151c256f853fcc3561ff2daeb72bb3c1175d03702823605b477926b8e8d"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/11/74/539e56497d9bd1d484fd863dd69cbbfa653cd2aa27abfe35653494d85e94/cfgv-3.4.0.tar.gz"
    sha256 "e52591d4c5f5dead8e0f673fb16db7949d2cfb3f7da4582893288f0ded8fe560"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/58/46/0028a82567109b5ef6e4d2a1f04a583fb513e6cf9527fcdd09afd817deeb/filelock-3.20.0.tar.gz"
    sha256 "711e943b4ec6be42e1d4e6690b48dc175c822967466bb31c0c293f34334c13f4"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/ff/e7/685de97986c916a6d93b3876139e00eef26ad5bbbd61925d670ae8013449/identify-2.6.15.tar.gz"
    sha256 "e4f4864b96c6557ef2a1e1c951771838f4edc9df3a72ec7118b338801b11c7bf"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/43/16/fc88b08840de0e0a72a2f9d8c6bae36be573e475a6326ae854bcc549fc45/nodeenv-1.9.1.tar.gz"
    sha256 "6ec12890a2dab7946721edbfbcd91f3319c6ccc9aec47be7c7e6b7011ee6645f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/20/28/e6f1a6f655d620846bd9df527390ecc26b3805a0c5989048c210e22c5ca9/virtualenv-20.35.4.tar.gz"
    sha256 "643d3914d73d3eeb0c552cbb12d7e82adf0e504dbf86a3182f8771a153a1971c"
  end

  def python3
    "python3.14"
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'INSTALL_PYTHON={shlex.quote(sys.executable)}\\n'",
              "f'INSTALL_PYTHON={shlex.quote(\"#{opt_libexec}/bin/#{python3}\")}\\n'"

    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    (testpath/".pre-commit-config.yaml").write <<~YAML
      repos:
      -   repo: https://github.com/pre-commit/pre-commit-hooks
          rev: v0.9.1
          hooks:
          -   id: trailing-whitespace
    YAML
    system bin/"pre-commit", "install"
    (testpath/"f").write "hi\n"
    system "git", "add", "f"

    ENV["GIT_AUTHOR_NAME"] = "test user"
    ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
    ENV["GIT_COMMITTER_NAME"] = "test user"
    ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"
    git_exe = which("git")
    ENV["PATH"] = "/usr/bin:/bin"
    system git_exe, "commit", "-m", "test"
  end
end
