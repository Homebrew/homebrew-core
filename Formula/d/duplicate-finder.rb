class DuplicateFinder < Formula
  include Language::Python::Virtualenv

  desc "Desktop application for finding and removing duplicate files"
  homepage "https://github.com/denis-peshkov/duplicate-finder"
  url "https://github.com/denis-peshkov/duplicate-finder/releases/download/v0.1.4/duplicate-finder-0.1.4-src.tar.gz"
  sha256 "db3fa87ae15bffc11a0ac156c1fdb7cf084a861b8183eccc8ea7a4247bbff733"
  license "MIT"

  depends_on "python-tk@3.12"
  depends_on "python@3.12"

  resource "customtkinter" do
    url "https://files.pythonhosted.org/packages/cf/48/c5a9d44188c44702e1e3db493c741e9c779596835a761b819fe15431d163/customtkinter-5.2.2.tar.gz"
    sha256 "fd8db3bafa961c982ee6030dba80b4c2e25858630756b513986db19113d8d207"
  end

  resource "darkdetect" do
    url "https://files.pythonhosted.org/packages/45/77/7575be73bf12dee231d0c6e60ce7fb7a7be4fcd58823374fc59a6e48262e/darkdetect-0.8.0.tar.gz"
    sha256 "b5428e1170263eb5dea44c25dc3895edd75e6f52300986353cd63533fe7df8b1"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "send2trash" do
    url "https://files.pythonhosted.org/packages/fd/3a/aec9b02217bb79b87bbc1a21bc6abc51e3d5dcf65c30487ac96c0908c722/Send2Trash-1.8.3.tar.gz"
    sha256 "b18e7a3966d99871aefeb00cfbcfdced55ce4871194810fc71f4aa484b953abf"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/duplicate-finder --version")
  end
end
