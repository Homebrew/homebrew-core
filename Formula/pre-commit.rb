class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/c9/31/5055de265076eb86e5088b5439aefb948b1aba23f2984aa9a075aae5d9e1/pre_commit-3.2.1.tar.gz"
  sha256 "b5aee7d75dbba21ee161ba641b01e7ae10c5b91967ebf7b2ab0dfae12d07e1f1"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37fad7396b7344f94d7596cfdbdfdae03a792fead4204e3baa67e72c596aa2c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37fad7396b7344f94d7596cfdbdfdae03a792fead4204e3baa67e72c596aa2c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37fad7396b7344f94d7596cfdbdfdae03a792fead4204e3baa67e72c596aa2c6"
    sha256 cellar: :any_skip_relocation, ventura:        "1eb8d2639bae8880f0f09eeb8080a2a89e4d91f47ea186b2c33d1894fd92a4da"
    sha256 cellar: :any_skip_relocation, monterey:       "1eb8d2639bae8880f0f09eeb8080a2a89e4d91f47ea186b2c33d1894fd92a4da"
    sha256 cellar: :any_skip_relocation, big_sur:        "1eb8d2639bae8880f0f09eeb8080a2a89e4d91f47ea186b2c33d1894fd92a4da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f22658172de8b255c98a47e4c0bb6f8a467934f1d2bf0885aeb360641da6c762"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "virtualenv"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/c4/bf/d0d622b660d414a47dc7f0d303791a627663f554345b21250e39e7acb48b/cfgv-3.3.1.tar.gz"
    sha256 "f5a830efb9ce7a445376bb66ec94c638a9787422f96264c98edc6bdeed8ab736"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/9c/85/2dad5866648c6b1772d5cb9b0ca1810f214e5d5e72f231dfb6891300358a/identify-2.5.22.tar.gz"
    sha256 "f7a93d6cf98e29bd07663c60728e7a4057615068d7a639d132dc883b2d54d31e"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/f3/9d/a28ecbd1721cd6c0ea65da6bfb2771d31c5d7e32d916a8f643b062530af3/nodeenv-1.7.0.tar.gz"
    sha256 "e0e7f7dfb85fc5394c6fe1e8fa98131a2473e04311a45afb6508f7cf1836fa2b"
  end

  def python3
    "python3.11"
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'INSTALL_PYTHON={shlex.quote(sys.executable)}\\n'",
              "f'INSTALL_PYTHON={shlex.quote(\"#{opt_libexec}/bin/#{python3}\")}\\n'"

    virtualenv_install_with_resources

    # we depend on virtualenv, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    virtualenv = Formula["virtualenv"].opt_libexec
    (libexec/site_packages/"homebrew-virtualenv.pth").write virtualenv/site_packages
  end

  # Avoid relative paths
  def post_install
    xy = Language::Python.major_minor_version Formula["python@3.11"].opt_bin/python3
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
