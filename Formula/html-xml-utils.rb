class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "https://www.w3.org/Tools/HTML-XML-utils/"
  url "https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-7.7.tar.gz"
  sha256 "99373637639bf1bd33c5d2a7c2c4cd4efc30dcf37350fc536c489a2370b998ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "0627bfa11adb31884d574f4d8f7bb22f1190464e435f23c278c88d413feae2fe" => :mojave
    sha256 "1d0db3459079f61ebf01e025558c5ce63cf3b096932d870e47199271b57b225c" => :high_sierra
    sha256 "c2f6bff7a920806db425704f379b072a656836c72016b9cc2458c170a4d635fe" => :sierra
    sha256 "ca7f5cc13b994275d3a923aad5a5f56b4af548f346da6a03ee201aa8113f2d7c" => :el_capitan
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
