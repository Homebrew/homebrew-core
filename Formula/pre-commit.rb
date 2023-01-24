class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/87/a2/169794a73e0ad229ddbe93b5b8da2060dd92f39df724eb38ccc55c7f84f1/pre_commit-3.0.0.tar.gz"
  sha256 "de265f74325f0c3ff1a727a974449315ea9b11975cf6b02c11f26e50acfa48f1"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f263ff1b1689dbf474b10b6ba7a3177ff93d23d941dd3a02ff4435298cc6bd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f263ff1b1689dbf474b10b6ba7a3177ff93d23d941dd3a02ff4435298cc6bd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f263ff1b1689dbf474b10b6ba7a3177ff93d23d941dd3a02ff4435298cc6bd0"
    sha256 cellar: :any_skip_relocation, ventura:        "dba52d85b254022a7c38b0da6b4ebdb2c80f247f4bde35cbcc94c2c33e858dca"
    sha256 cellar: :any_skip_relocation, monterey:       "dba52d85b254022a7c38b0da6b4ebdb2c80f247f4bde35cbcc94c2c33e858dca"
    sha256 cellar: :any_skip_relocation, big_sur:        "dba52d85b254022a7c38b0da6b4ebdb2c80f247f4bde35cbcc94c2c33e858dca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7d3dc2b1f79bedf6c2e2bd784db8771a2d3443d14cf28bbcc683d24e7b10b22"
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
    url "https://files.pythonhosted.org/packages/82/a9/3cf658d585698e8f14b09011018f4f3fd9d56b0eecefb79de89ec5cb6a92/identify-2.5.15.tar.gz"
    sha256 "c22aa206f47cc40486ecf585d27ad5f40adbfc494a3fa41dc3ed0499a23b123f"
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
