class Epstool < Formula
  desc "Edit preview images and fix bounding boxes in EPS files"
  homepage "http://www.ghostgum.com.au/software/epstool.htm"
  url "https://deb.debian.org/debian/pool/main/e/epstool/epstool_3.09.orig.tar.xz"
  mirror "https://dl.bintray.com/homebrew/mirror/epstool-3.09.tar.xz"
  sha256 "1e85249d1a44f9418b1f95a3aebd8b0784dab8e49deb6417ac9b996ca08f6011"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ef026d6cc575da86e43741df6a9f5419269bea22e8db6c6296811112678c690" => :catalina
    sha256 "497608077aea90c569aab7929a8a9ea19d91ba70f4743d982bcb63c1d3a48d7b" => :mojave
    sha256 "47ab226f0e5d93a3b91b43d519de370d046410946e280958ef9106fdbc4ef115" => :high_sierra
  end

  depends_on "ghostscript"

  def install
    system "make", "install",
                   "EPSTOOL_ROOT=#{prefix}",
                   "EPSTOOL_MANDIR=#{man}",
                   "CC=#{ENV.cc}"
  end

  test do
    system bin/"epstool", "--add-tiff-preview", "--device", "tiffg3", test_fixtures("test.eps"), "test2.eps"
    assert_predicate testpath/"test2.eps", :exist?
  end
end
