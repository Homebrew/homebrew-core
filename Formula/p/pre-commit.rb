class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/88/e8/4330d06f2b00ad3a9c66e07a68fe23f70233a4e7e1aaba5a738a93d2cb5d/pre_commit-3.6.0.tar.gz"
  sha256 "d30bad9abf165f7785c15a21a1f46da7d0677cb00ee7ff4c579fd38922efe15d"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bc88b06e4238db4b55e1af64cb7fef785ccec3b88bc8dd2c5814ebc8f55b0a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc76862c28b49b83d7a15b484a5186cd6d20a03d60d3b0f9d3afba5d863526a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb7abe34c1d15f3a96b258fbedcdbde6c24e89927e1b35610358db9e70204a44"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e285ca1bbf5f86e53240c97041e1133d286e05256c5ca9658bb86ed5087b789"
    sha256 cellar: :any_skip_relocation, ventura:        "07dd83234a749a5307c506a5442ff2f818084aea2d1436e11797fb493447f0ca"
    sha256 cellar: :any_skip_relocation, monterey:       "2b23e12b4fc2226d97830982b103f1b5be54707c1ebd638616cf0d614b9a2dd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1984c2637a432088c3d98ad10e9219afa6612387718a16cb076927ee39dc0ea5"
  end

  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "virtualenv"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/11/74/539e56497d9bd1d484fd863dd69cbbfa653cd2aa27abfe35653494d85e94/cfgv-3.4.0.tar.gz"
    sha256 "e52591d4c5f5dead8e0f673fb16db7949d2cfb3f7da4582893288f0ded8fe560"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/61/a0/92aba7e128faadab9db785c1f8cc442caf51cba5a55b575abb211b12526f/identify-2.5.33.tar.gz"
    sha256 "161558f9fe4559e1557e1bff323e8631f6a0e4837f7497767c1782832f16b62d"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/48/92/8e83a37d3f4e73c157f9fcf9fb98ca39bd94701a469dc093b34dca31df65/nodeenv-1.8.0.tar.gz"
    sha256 "d51e0c37e64fbf47d017feac3145cdbb58836d7eee8c6f6d3b6880c5456227d2"
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

    # we depend on virtualenv, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.12")
    virtualenv = Formula["virtualenv"].opt_libexec
    (libexec/site_packages/"homebrew-virtualenv.pth").write virtualenv/site_packages
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
