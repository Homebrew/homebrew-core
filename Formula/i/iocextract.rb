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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3291dd2f7c51a9d144c83f0c2e28e11ae4e8225004c68363f64a79a015c86d17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2eea8bd42f63a2c26087d2257ea2b711984dbe5904ea81ceee5c1fdc1dfdcb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf86024794b66d89ec3f4dab45c6c4d1c73ea80795d3f58f2f9d158cd8609522"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b3bfbda26fac498e6d27616bfa2c5aaef0dd252c7ed153d1db4b9887046e127"
    sha256 cellar: :any_skip_relocation, sonoma:        "15ed54c9a7d2232843b490de0eaf5514dd5e3d9ed41e980132746b7b1b24dcca"
    sha256 cellar: :any_skip_relocation, ventura:       "9021fed290b2a1b1674e7a688b998fa3b85601112aa0cbaa1127b23305fe3757"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e57c9778a3db7c1e352afc83530f273dad9eb3f25bd722ee96deea538d38422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03c618abee9efc6760137ce02332098ace098e8c9f5d81d4a6a9c64036e946a7"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/0b/de/e13fa6dc61d78b30ba47481f99933a3b49a57779d625c392d8036770a60d/regex-2025.7.34.tar.gz"
    sha256 "9ead9765217afd04a86822dfcd4ed2747dfe426e887da413b15ff0ac2457e21a"
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
