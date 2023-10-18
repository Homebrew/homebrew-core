class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/04/b3/4ae08d21eb097162f5aad37f4585f8069a86402ed7f5362cc9ae097f9572/pre_commit-3.5.0.tar.gz"
  sha256 "5804465c675b659b0862f07907f96295d490822a450c4c40e747d0b1c6ebcb32"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28ce6ba6dd59ec13eacac4a1b171c1ed099e9f127de5a8a6cee7f7dc9432d64f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d82241c3f04f0a03c29b49a719fe5ed64339c091198feda4bdd0b8eca68aa9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c94e5d2a1c99ea66b776e5ac94e106bd671a11a0af4c10957d1b841da5adeaa5"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb14ef95acfd9a43fcf2787af5bb9f45afc54828a403366ddf46c9b155f4b1cc"
    sha256 cellar: :any_skip_relocation, ventura:        "c95137bd9a0f1b4416bedfabd26f91f0631b5373634fb6b777a32d31eaf39508"
    sha256 cellar: :any_skip_relocation, monterey:       "d61c2f8e66bc52d521d0bbdd3beeeb6ea7fe1aae208a88c9e3331de0993e9cc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7307ff518d8fbe92e6dba41c51e9de5abee076b54ec23dc00f7cf5d4da0f4370"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "virtualenv"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/11/74/539e56497d9bd1d484fd863dd69cbbfa653cd2aa27abfe35653494d85e94/cfgv-3.4.0.tar.gz"
    sha256 "e52591d4c5f5dead8e0f673fb16db7949d2cfb3f7da4582893288f0ded8fe560"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/5f/19/f3aa63b65be4cdf23ba26984aa04cb21fa04fccfef68355919edafee025c/identify-2.5.30.tar.gz"
    sha256 "f302a4256a15c849b91cfcdcec052a8ce914634b2f77ae87dad29cd749f2d88d"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/48/92/8e83a37d3f4e73c157f9fcf9fb98ca39bd94701a469dc093b34dca31df65/nodeenv-1.8.0.tar.gz"
    sha256 "d51e0c37e64fbf47d017feac3145cdbb58836d7eee8c6f6d3b6880c5456227d2"
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
