class Iocextract < Formula
  include Language::Python::Virtualenv

  desc "Defanged indicator of compromise extractor"
  homepage "https://inquest.readthedocs.io/projects/iocextract/en/latest/"
  url "https://files.pythonhosted.org/packages/ad/4b/19934df6cd6a0f6923aabae391a67b630fdd03c12c1226377c99a747a4f1/iocextract-1.16.1.tar.gz"
  sha256 "ec1389a76a5083f643652579610e8313d27ed5821fc57e7b046c23ddec181d44"
  license "GPL-2.0-only"
  revision 8
  head "https://github.com/InQuest/iocextract.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31c12d5fd8e46848a5a35905b7dea98f547fea01dcdae8ee6bf244b6396ffa0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c946ca9ee349de4759321f4f07508ea639865b61247d0b50f85823375d1d5f66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f50f86c15d5fe7b3cbcdd8ed01461ca0e26de18b7af6533c843ef3ab2cc97c19"
    sha256 cellar: :any_skip_relocation, sonoma:        "75652df63a121954ae6867259dfd2c01409a92e4df0e61254a86052b680c479f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0f175e68cf2017c28b20d86a5f688c0c845a7fd6b495e3738ab7ee564f755d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ce8cb6e21d75d91e43401721abee8ccbb72ee778b360a6e7098ecec8ef0ff3e"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi",
                extra_packages:   "requests"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/49/d3/eaa0d28aba6ad1827ad1e716d9a93e1ba963ada61887498297d3da715133/regex-2025.9.18.tar.gz"
    sha256 "c5ba23274c61c6fef447ba6a39333297d0c247f53059dba0bca415cac511edc4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write <<~EOS
      InQuest customers have had detection for threats delivered from hotfixmsupload[.]com
      since 6/3/2017 and cdnverify[.]net since 2/1/18.
    EOS

    assert_match "hotfixmsupload[.]com\ncdnverify[.]net", shell_output("#{bin}/iocextract -i #{testpath}/test.txt")
  end
end
