class Nox < Formula
  include Language::Python::Virtualenv

  desc "Flexible test automation for Python"
  homepage "https://nox.thea.codes/"
  url "https://files.pythonhosted.org/packages/1e/86/b86fc26784d2f63d038b4efc9e18d4d807ec025569da66c6d032b8f717df/nox-2024.4.15.tar.gz"
  version "2024.04.15"
  sha256 "ecf6700199cdfa9e5ea0a41ff5e6ef4641d09508eda6edb89d9987864115817f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4125816ab344b179b2ab09b3f392a75efa1c8e7fc6acb44a30709b9d31f2c94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4125816ab344b179b2ab09b3f392a75efa1c8e7fc6acb44a30709b9d31f2c94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4125816ab344b179b2ab09b3f392a75efa1c8e7fc6acb44a30709b9d31f2c94"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bcbd553a4a0ecc80173c998a94561fe5456531a330c19203f9b5cff5288388d"
    sha256 cellar: :any_skip_relocation, ventura:        "5bcbd553a4a0ecc80173c998a94561fe5456531a330c19203f9b5cff5288388d"
    sha256 cellar: :any_skip_relocation, monterey:       "5bcbd553a4a0ecc80173c998a94561fe5456531a330c19203f9b5cff5288388d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "092e78bcaf5222fed54a3f3be554d616707b4f68d9df72c929272dbb50599a1b"
  end

  depends_on "python@3.12"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/79/51/fd6e293a64ab6f8ce1243cf3273ded7c51cbc33ef552dce3582b6a15d587/argcomplete-3.3.0.tar.gz"
    sha256 "fd03ff4a5b9e6580569d34b273f741e85cd9e072f3feeeee3eba4891c70eda62"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/db/38/2992ff192eaa7dd5a793f8b6570d6bbe887c4fbbf7e72702eb0a693a01c8/colorlog-6.8.2.tar.gz"
    sha256 "3e3e079a41feb5a1b64f978b5ea4f46040a94f11f0e8bbb8261e3dbbeca64d44"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/38/ff/877f1dbe369a2b9920e2ada3c9ab81cf6fe8fa2dce45f40cad510ef2df62/filelock-3.13.4.tar.gz"
    sha256 "d13f466618bfde72bd2c18255e269f72542c6e70e7bac83a0232d6b1cc5c8cf4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/93/4f/a7737e177ab67c454d7e60d48a5927f16cd05623e9dd888f78183545d250/virtualenv-20.25.1.tar.gz"
    sha256 "e08e13ecdca7a0bd53798f356d5831434afa5b07b93f0abdf0797b7a06ffe197"
  end

  def install
    virtualenv_install_with_resources
    (bin/"tox-to-nox").unlink
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"noxfile.py").write <<~EOS
      import nox

      @nox.session
      def tests(session):
          session.install("pytest")
          session.run("pytest")
    EOS
    (testpath/"test_trivial.py").write <<~EOS
      def test_trivial():
          assert True
    EOS
    assert_match "usage", shell_output("#{bin}/nox --help")
    assert_match "Sessions defined in #{testpath}/noxfile.py", shell_output("#{bin}/nox --list-sessions")
  end
end
