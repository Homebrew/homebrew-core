class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/1f/a7/37bb57af1681e945c0f4237a6f2da562bc54dd42db103ee9f6b41a958289/pre_commit-3.6.1.tar.gz"
  sha256 "c90961d8aa706f75d60935aba09469a6b0bcb8345f127c3fbee4bdc5f114cf4b"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08f2db39e5f4d3350235ecde59cade0f825ddb13329016256ca99a3a22091773"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b9efad076f3a545e1c60d4c2c83fce843af9305f0e6292f99fdb51c882506b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a216a242d36039c95bd6c0c4cfbd47ce7df60426476f326d7156e6ddba48d87c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ff38d68f92949033f7488126a21482e715c1af5e620e529c33525f6157b1177"
    sha256 cellar: :any_skip_relocation, ventura:        "cf0397e24eff88183b4b160949c4c2a9fd76ce6b28234444bf05420621aab9cf"
    sha256 cellar: :any_skip_relocation, monterey:       "847cdd7b2cff6a461930421c25954bc45d49106e8b33faf14c6fbe7ac3337a9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44f9ab2fb9ede8843e8cd948e6f59dbb548d9aa6e31d81f4c3e999cfe08e13ab"
  end

  depends_on "python@3.12"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/11/74/539e56497d9bd1d484fd863dd69cbbfa653cd2aa27abfe35653494d85e94/cfgv-3.4.0.tar.gz"
    sha256 "e52591d4c5f5dead8e0f673fb16db7949d2cfb3f7da4582893288f0ded8fe560"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/70/40/6df30e7ec1934ad43736248bb2c2800782fba42bad2bfda91b514cf7bdea/identify-2.5.34.tar.gz"
    sha256 "ee17bc9d499899bc9eaec1ac7bf2dc9eedd480db9d88b96d123d3b64a9d34f5d"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/48/92/8e83a37d3f4e73c157f9fcf9fb98ca39bd94701a469dc093b34dca31df65/nodeenv-1.8.0.tar.gz"
    sha256 "d51e0c37e64fbf47d017feac3145cdbb58836d7eee8c6f6d3b6880c5456227d2"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c9/3d/74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fad/setuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/94/d7/adb787076e65dc99ef057e0118e25becf80dd05233ef4c86f07aa35f6492/virtualenv-20.25.0.tar.gz"
    sha256 "bf51c0d9c7dd63ea8e44086fa1e4fb1093a31e963b86959257378aef020e1f1b"
  end

  def python3
    "python3.12"
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'INSTALL_PYTHON={shlex.quote(sys.executable)}\\n'",
              "f'INSTALL_PYTHON={shlex.quote(\"#{opt_libexec}/bin/#{python3}\")}\\n'"

    virtualenv_install_with_resources
  end

  # Avoid relative paths
  def post_install
    xy = Language::Python.major_minor_version Formula["python@3.12"].opt_bin/python3
    dirs_to_fix = [libexec/"lib/python#{xy}"]
    dirs_to_fix << (libexec/"bin") if OS.linux?
    dirs_to_fix.each do |folder|
      folder.each_child do |f|
        next unless f.symlink?

        realpath = f.realpath
        rm f
        ln_s realpath, f
      end
    end
  end

  test do
    system "git", "init"
    (testpath/".pre-commit-config.yaml").write <<~EOS
      repos:
      -   repo: https://github.com/pre-commit/pre-commit-hooks
          rev: v0.9.1
          hooks:
          -   id: trailing-whitespace
    EOS
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
