class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/ff/29/7cf5bbc236333876e4b41f56e06857a87937ce4bf91e117a6991a2dbb02a/pre_commit-4.3.0.tar.gz"
  sha256 "499fe450cc9d42e9d58e606262795ecb64dd05438943c62b66f6a8673da30b16"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "43edc617080f7dffe1319f7de8dc182e0cfc6719b2b0ce3c4cf94a23f0bcee4c"
    sha256 cellar: :any,                 arm64_sequoia: "5003a9e507228ba2e1cab97878504c7aebee61c9832a9cd30fd21019eca42b9c"
    sha256 cellar: :any,                 arm64_sonoma:  "9cc0ffb7e8e73cdda810e8dc723db227d808907f9919fcab60d627b4b4118d91"
    sha256 cellar: :any,                 arm64_ventura: "2265e0c22132c9e20cb6a0c98d9ee815669fef0a00e4494e952478d5fcdff413"
    sha256 cellar: :any,                 sonoma:        "2a8095a8a1c1ee05a97eb03d6779d48e55c89ed2b1b04a9870e60a61e6c6afc9"
    sha256 cellar: :any,                 ventura:       "36ada427dbca0b40ba4055948ef7f5bb0577baf3ad04fe2be56c3837d0bc94dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02683330b0260a6fd99ed9822751a36bd5235e5abe0e4b7a7c750401a0f8027f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b06638faa4357af75024c04285840b21c3878ab8657e3c6e850191e6676cccfb"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/11/74/539e56497d9bd1d484fd863dd69cbbfa653cd2aa27abfe35653494d85e94/cfgv-3.4.0.tar.gz"
    sha256 "e52591d4c5f5dead8e0f673fb16db7949d2cfb3f7da4582893288f0ded8fe560"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/82/ca/ffbabe3635bb839aa36b3a893c91a9b0d368cb4d8073e03a12896970af82/identify-2.6.13.tar.gz"
    sha256 "da8d6c828e773620e13bfa86ea601c5a5310ba4bcd65edf378198b56a1f9fb32"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/43/16/fc88b08840de0e0a72a2f9d8c6bae36be573e475a6326ae854bcc549fc45/nodeenv-1.9.1.tar.gz"
    sha256 "6ec12890a2dab7946721edbfbcd91f3319c6ccc9aec47be7c7e6b7011ee6645f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/8b/60/4f20960df6c7b363a18a55ab034c8f2bcd5d9770d1f94f9370ec104c1855/virtualenv-20.33.1.tar.gz"
    sha256 "1b44478d9e261b3fb8baa5e74a0ca3bc0e05f21aa36167bf9cbf850e542765b8"
  end

  def python3
    "python3.13"
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
