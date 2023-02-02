class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/97/e9/26c7a792c8793e844ccfdac1e832136909f9a49dde32550b961edfacb51e/pre_commit-3.0.3.tar.gz"
  sha256 "4187e74fda38f0f700256fb2f757774385503b04292047d0899fc913207f314b"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd540fb7e4491d2ca05fb509e2612fb354a8b18b1f5b46b442e549331f434313"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd540fb7e4491d2ca05fb509e2612fb354a8b18b1f5b46b442e549331f434313"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd540fb7e4491d2ca05fb509e2612fb354a8b18b1f5b46b442e549331f434313"
    sha256 cellar: :any_skip_relocation, ventura:        "6300812cd4674caff7b0c337de18b59018c01d6779d988490d2ba25c0e83e2e0"
    sha256 cellar: :any_skip_relocation, monterey:       "6300812cd4674caff7b0c337de18b59018c01d6779d988490d2ba25c0e83e2e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6300812cd4674caff7b0c337de18b59018c01d6779d988490d2ba25c0e83e2e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f28f90e8b1679953b53993f0e99e9f93cbc841ff043d765051db6cf4226df9e"
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
    url "https://files.pythonhosted.org/packages/6b/c1/dcb61490b9324dd6c4b071835ce89840536a636512100e300e67e27ab447/identify-2.5.17.tar.gz"
    sha256 "93cc61a861052de9d4c541a7acb7e3dcc9c11b398a2144f6e52ae5285f5f4f06"
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
