class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/21/55/fccc69a49b66c54dcb9a7d8620131a2566db973837c6611b516a2d4e87d7/pre_commit-3.3.2.tar.gz"
  sha256 "66e37bec2d882de1f17f88075047ef8962581f83c234ac08da21a0c58953d1f0"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "236c394b092cc2f0f6f650ee50b14c3660634f4a3cf6902f8a8cf27227acd929"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "459b8a36eb20d684eea0eff22d47a140900c0a59bb81c19f69fff4f798dc7623"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ea75a9334c106db102523cc4c16a33faea8a5594e17ae68a1e04b48055c43e9"
    sha256 cellar: :any_skip_relocation, ventura:        "a731ce715260980fd09f8baba753047eb4f704779e8b22509bdfe1d0a8b59a9b"
    sha256 cellar: :any_skip_relocation, monterey:       "89ae87d1b95baa1ee14a020cd8b03f10d37e913b1ad9dabe94e34be623e77d2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "80d1060c3b531102f422d0dac9c726a650f6933a3118723c6f4d55ed1100f8a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45d757989b4610fb0a48ef96c268f20541f09ce971dee33070b9a1878e87f687"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "virtualenv"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/c4/bf/d0d622b660d414a47dc7f0d303791a627663f554345b21250e39e7acb48b/cfgv-3.3.1.tar.gz"
    sha256 "f5a830efb9ce7a445376bb66ec94c638a9787422f96264c98edc6bdeed8ab736"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/24/85/cf4df939cc0a037ebfe18353005e775916faec24dcdbc7a2f6539ad9d943/filelock-3.12.0.tar.gz"
    sha256 "fc03ae43288c013d2ea83c8597001b1129db351aad9c57fe2409327916b8e718"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/c4/f8/498e13e408d25ee6ff04aa0acbf91ad8e9caae74be91720fc0e811e649b7/identify-2.5.24.tar.gz"
    sha256 "0aac67d5b4812498056d28a9a512a483f5085cc28640b02b258a59dac34301d4"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/48/92/8e83a37d3f4e73c157f9fcf9fb98ca39bd94701a469dc093b34dca31df65/nodeenv-1.8.0.tar.gz"
    sha256 "d51e0c37e64fbf47d017feac3145cdbb58836d7eee8c6f6d3b6880c5456227d2"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9c/0e/ae9ef1049d4b5697e79250c4b2e72796e4152228e67733389868229c92bb/platformdirs-3.5.1.tar.gz"
    sha256 "412dae91f52a6f84830f39a8078cecd0e866cb72294a5c66808e74d5e88d251f"
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
