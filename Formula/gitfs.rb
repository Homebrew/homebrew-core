class Gitfs < Formula
  include Language::Python::Virtualenv

  desc "Version controlled file system"
  homepage "https://www.presslabs.com/gitfs"
  url "https://github.com/presslabs/gitfs/archive/0.5.2.tar.gz"
  sha256 "921e24311e3b8ea3a5448d698a11a747618ee8dd62d5d43a85801de0b111cbf3"
  license "Apache-2.0"
  revision 10
  head "https://github.com/presslabs/gitfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1ac6487bbdd1000763469c43e998a72f9bc64c7e0704b99067aad84d003d32d1"
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "libfuse"
  depends_on "libgit2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "python@3.9"

  resource "atomiclong" do
    url "https://files.pythonhosted.org/packages/86/8c/70aea8215c6ab990f2d91e7ec171787a41b7fbc83df32a067ba5d7f3324f/atomiclong-0.1.1.tar.gz"
    sha256 "cb1378c4cd676d6f243641c50e277504abf45f70f1ea76e446efcdbb69624bbe"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/57/8e/0698e10350a57d46b3bcfe8eff1d4181642fd1724073336079cb13c5cf7f/cached-property-1.5.1.tar.gz"
    sha256 "9217a59f14a5682da7c4b8829deadbfc194ac22e9908ccf7c8820234e80a1504"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/93/1a/ab8c62b5838722f29f3daffcc8d4bd61844aa9b5f437341cc890ceee483b/cffi-1.12.3.tar.gz"
    sha256 "041c81822e9f84b1d9c401182e174996f0bae9991f33725d059b771744290774"
  end

  resource "fusepy" do
    url "https://files.pythonhosted.org/packages/04/0b/4506cb2e831cea4b0214d3625430e921faaa05a7fb520458c75a2dbd2152/fusepy-3.0.1.tar.gz"
    sha256 "72ff783ec2f43de3ab394e3f7457605bf04c8cf288a2f4068b4cde141d4ee6bd"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/e7/8a/e52a1c8b9878e9d9743089393f8289bb9c8a81eaab722df22df46a38b9e9/pygit2-1.10.0.tar.gz"
    sha256 "7c751eee88c731b922e4e487ee287e2e40906b2bd32d0bfd2105947f63e867de"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "raven" do
    url "https://files.pythonhosted.org/packages/79/57/b74a86d74f96b224a477316d418389af9738ba7a63c829477e7a86dd6f47/raven-6.10.0.tar.gz"
    sha256 "3fa6de6efa2493a7c827472e984ce9b020797d0da16f1db67197bcc23c8fae54"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    python = "python3.9"
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python)

    (testpath/"test.py").write <<~EOS
      import gitfs
      import pygit2
      pygit2.init_repository('testing/.git', True)
    EOS

    system python, "test.py"
    assert_predicate testpath/"testing/.git/config", :exist?
    cd "testing" do
      system "git", "remote", "add", "homebrew", "https://github.com/Homebrew/homebrew-core.git"
      assert_match "homebrew", shell_output("git remote")
    end
  end
end
