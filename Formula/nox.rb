class Nox < Formula
  include Language::Python::Virtualenv

  desc "Flexible test automation for Python"
  homepage "https://nox.thea.codes/"
  url "https://files.pythonhosted.org/packages/85/35/377b34ff5593be0dd832828b4f3fec25b98d1ada138c5c0e11de2fa8ca27/nox-2020.12.31.tar.gz"
  sha256 "58a662070767ed4786beb46ce3a789fca6f1e689ed3ac15c73c4d0094e4f9dc4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4ce7eed9cc2446ce8fee3a924280813ccc3f7eeb6a104672f76606fa353bcf86"
    sha256 cellar: :any_skip_relocation, big_sur:       "cc46720ed1ca9e428193b610275fe33e728400e3cc4fd0c475c53005f9d53a91"
    sha256 cellar: :any_skip_relocation, catalina:      "c29746c5cab8bf759cd839531bb2528fa08d305197e1c891136cdb48fbc8fd4b"
    sha256 cellar: :any_skip_relocation, mojave:        "d2950d714baca5dd6ec329d2da4d7f79c09211be12f682cacc338e551f90b8ad"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6a/b4/3b1d48b61be122c95f4a770b2f42fc2552857616feba4d51f34611bd1352/argcomplete-1.12.3.tar.gz"
    sha256 "2c7dbffd8c045ea534921e63b0be6fe65e88599990d8dc408ac8c542b72a5445"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/75/32/cdfba08674d72fe7895a8ec7be8f171e8502274999cae9497e4545404873/colorlog-4.8.0.tar.gz"
    sha256 "59b53160c60902c405cdec28d38356e09d40686659048893e026ecbd589516b1"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/2f/83/1eba07997b8ba58d92b3e51445d5bf36f9fba9cb8166bcae99b9c3464841/distlib-0.3.1.zip"
    sha256 "edf6116872c863e1aa9d5bb7cb5e05a022c519a4594dc703843343a9ddd9bff1"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/14/ec/6ee2168387ce0154632f856d5cc5592328e9cf93127c5c9aeca92c8c16cb/filelock-3.0.12.tar.gz"
    sha256 "18d82244ee114f543149c66a6e0c14e9c4f8a1044b5cdaadd0f82159d6a6ff59"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/0d/8c/50e9f3999419bb7d9639c37e83fa9cdcf0f601a9d407162d6c37ad60be71/py-1.10.0.tar.gz"
    sha256 "21b81bda15b66ef5e1a777a21c4dcd9c20ad3efd0b3f817e7a809035269e1bd3"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/ca/5d/c746f030903a75fd428851560f2895a16a5065ed53a69c232c4beb0eafb4/virtualenv-20.4.4.tar.gz"
    sha256 "09c61377ef072f43568207dc8e46ddeac6bcdcaf288d49011bda0e7f4d38c4a2"
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
    assert_match "1 passed", shell_output("#{bin}/nox")
  end
end
