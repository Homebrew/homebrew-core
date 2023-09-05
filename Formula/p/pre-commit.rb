class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/56/a5/cb576829ab7c94e768221cf0629e0da8519e744d993e0c99a6ae9803babd/pre_commit-3.4.0.tar.gz"
  sha256 "6bbd5129a64cad4c0dfaeeb12cd8f7ea7e15b77028d985341478c8af3c759522"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f805e7aef476961d05d917f846fdc193d026beee9888bb164de3bcac34d46654"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7614dc76543c06da4a02ca373a4f9ccef40f04da6e566e9dd6aa4411aea85b2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a802652a2de1f0208a2a0d0a56ffdb043bb2034d85b432558d9d832965b4c5d"
    sha256 cellar: :any_skip_relocation, ventura:        "b0d34b959e501e4300d1ab10d0da007b387105a8287d8aa97b2bff7c4cf8b556"
    sha256 cellar: :any_skip_relocation, monterey:       "d72d3bc75d34c682ecae96ec2c26898cd809603adc72dcc1594e53abdc017957"
    sha256 cellar: :any_skip_relocation, big_sur:        "58e11d4df428a26de3e6f88a6c0cd1585d4d41ffe36240fc1bc253157cd75ab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb7deac6b6bdae5ef93eb12a794fe6096b6b8f759059afcaad8fb3e321122fc4"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "virtualenv"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/11/74/539e56497d9bd1d484fd863dd69cbbfa653cd2aa27abfe35653494d85e94/cfgv-3.4.0.tar.gz"
    sha256 "e52591d4c5f5dead8e0f673fb16db7949d2cfb3f7da4582893288f0ded8fe560"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/e0/7e/dc9ae38e2944611174051371e62cb79a9fd98fd8b4e4f07d0c1fbf2bb260/identify-2.5.27.tar.gz"
    sha256 "287b75b04a0e22d727bc9a41f0d4f3c1bcada97490fa6eabb5b28f0e9097e733"
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
