class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/ea/2b/8999b0cfde3c72f153c489e93a6a5e8621a7e57f33f6fa78942bb771d79e/pre_commit-3.1.1.tar.gz"
  sha256 "d63e6537f9252d99f65755ae5b79c989b462d511ebbc481b561db6a297e1e865"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d3b52395b44c16599ecab9d67ba9302ef129e7afd53f56dfd85d2a230bcadd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d3b52395b44c16599ecab9d67ba9302ef129e7afd53f56dfd85d2a230bcadd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d3b52395b44c16599ecab9d67ba9302ef129e7afd53f56dfd85d2a230bcadd2"
    sha256 cellar: :any_skip_relocation, ventura:        "982df5dcbe626aa1b1e6d537e288851671fbc9da0588784b830badc0a1d3de04"
    sha256 cellar: :any_skip_relocation, monterey:       "982df5dcbe626aa1b1e6d537e288851671fbc9da0588784b830badc0a1d3de04"
    sha256 cellar: :any_skip_relocation, big_sur:        "982df5dcbe626aa1b1e6d537e288851671fbc9da0588784b830badc0a1d3de04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36087d8a8a8f4fe754dec1b5cc84b9c3ab0639733357c139c68cfce58e124793"
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
    url "https://files.pythonhosted.org/packages/08/36/eb2b142e245f69b0cf7b91a3f48769e414f681bd7ee04206ec0eba485e56/identify-2.5.18.tar.gz"
    sha256 "89e144fa560cc4cffb6ef2ab5e9fb18ed9f9b3cb054384bab4b95c12f6c309fe"
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
