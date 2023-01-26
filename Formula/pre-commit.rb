class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/5f/8f/35c30b0f1647014867f8b9bd36ae33faa88fd2ec8e59e62686b0e38b6122/pre_commit-3.0.1.tar.gz"
  sha256 "3a3f9229e8c19a626a7f91be25b3c8c135e52de1a678da98eb015c0d0baea7a5"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41596a0fe4ea1f6e8fb32e69e946265b00ee9dac2301ca070299d07ed3d5a7d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41596a0fe4ea1f6e8fb32e69e946265b00ee9dac2301ca070299d07ed3d5a7d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41596a0fe4ea1f6e8fb32e69e946265b00ee9dac2301ca070299d07ed3d5a7d7"
    sha256 cellar: :any_skip_relocation, ventura:        "17dea8ee6c4a584cefe708957bfce4f63f2fddae12cd49bbb3ed4ef54c129553"
    sha256 cellar: :any_skip_relocation, monterey:       "17dea8ee6c4a584cefe708957bfce4f63f2fddae12cd49bbb3ed4ef54c129553"
    sha256 cellar: :any_skip_relocation, big_sur:        "17dea8ee6c4a584cefe708957bfce4f63f2fddae12cd49bbb3ed4ef54c129553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf9bc6356089c69c3d154f06034d20b18261a4ecbd2d8e47a077339e2365c15b"
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
