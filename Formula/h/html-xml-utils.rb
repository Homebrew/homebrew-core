class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "https://www.w3.org/Tools/HTML-XML-utils/"
  url "https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-8.6.tar.gz"
  sha256 "5e84729ef36ccd3924d2872ed4ee6954c63332dca5400ba8eb4eaef1f2db4fb2"
  license "W3C"

  livecheck do
    url :homepage
    regex(/href=.*?html-xml-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d006846523d033cb674f9e9d62004221149184f75631668f7aee24f8e99d8f9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79efbafe7ae7adae1f605960f695b05b9d109ecd4646c0b2d66af0ebf2437cb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61a7fa1820b923739046d869de9ecfbc5c13c5ac073da1a6e4fd63d6a61b25af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0148c9b6bfd501d437d0533c79aba9166bcace206b938b852186b08ec4702008"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c6702650ee3b2a69abf343e531dde2ec22ccef5bee275f2715aa68536470f1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e44cc8827e9de4dbfe28b6679dba91e476e462748faf484c6a094beb52f1ee5"
    sha256 cellar: :any_skip_relocation, ventura:        "596832bcf2700b76b8d35f4b1e973f6bf3a67c5f999015215582154aa2402684"
    sha256 cellar: :any_skip_relocation, monterey:       "7f4d59ddda6304638418dc439db6d5c278443bf8a9d700e6bea06627116b33c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1b0270881457aa0b1ca7092f6be52476e4c67cd2056cb4b9597f2cde1d36fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d263a0a8834c74df434744a26b09e44687b32fd8e5dd5940ebd58101afb2c6e0"
  end

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize # install is not thread-safe
    system "make", "install"
  end

  test do
    assert_equal "&#20320;&#22909;", pipe_output("#{bin}/xml2asc", "你好")
  end
end
