class OnionLocation < Formula
  include Language::Python::Virtualenv

  desc "Discover advertised Onion-Location for given URLs"
  homepage "https://codeberg.org/Freso/python-onion-location"
  url "https://files.pythonhosted.org/packages/72/0d/e2656bdb8c66dc590da40622ca843f0513cd6f4b78bb1f9b6ed4592d283e/onion_location-0.1.0.tar.gz"
  sha256 "37dc14eab3a22b8948f8301542344144682108d1564289482827dc45106ee1d5"
  license "AGPL-3.0-or-later"
  revision 4
  head "https://codeberg.org/Freso/python-onion-location.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7691662320756b6a087b25ae765603ec9a2584a383c5e86370bd0f7d9e06d283"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "262e38dd420593b5e6e24ff9de2b417c19a08d8346cc4d72c3eb56d405c3f949"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d4c3afe2151a0ff9554292872d9f0a350e2c4e35132201a7e4ebf37b274d32a4"
    sha256 cellar: :any,                 arm64_linux:       "73c815c4d0f88a6a6e43e59bdc5da6f25e5496d88e4c1c92490d62ceb26f74fa"
    sha256 cellar: :any,                 x86_64_linux:      "2a37969b83a7e6a1125359b9fad16c7b9fc46eba654d5e82d56d8a96b8725f87"
  end

  depends_on "python@3.15"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "bs4" do
    url "https://files.pythonhosted.org/packages/c9/aa/4acaf814ff901145da37332e05bb510452ebed97bc9602695059dd46ef39/bs4-0.0.2.tar.gz"
    sha256 "a48685c58f50fe127722417bae83fe6badf500d54b55f7e39ffe43b798653925"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/0e/b9/014459776d0be4dd5f0c196fd2c8dc523a4b817a561667fae4f330b04b48/soupsieve-3.0.1.tar.gz"
    sha256 "713d5c69f90ef84deffec0b9c6244796575e3c9fc9081cefb96091ce1200a308"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "http://2gzyxa5ihm7nsggfxnu52rck2vv4rvmdlkiu3zzui5du4xyclen53wid.onion/index.html",
      shell_output("#{bin}/onion-location https://www.torproject.org/")
  end
end
