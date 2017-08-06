class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V1.9.2_src.zip"
  version "1.9.2"
  sha256 "4d61ae0b91686dea721d34df2e44eaf36c88da87086fd50ccc4e999a58e9ce90"
  revision 1

  bottle do
    cellar :any
    sha256 "16e9c9b366d2d7838969c8fa519a954babba3b2c7ef329aa629d077634a19484" => :sierra
    sha256 "f7d42ad6d64cd3af91453f6f559ce06ea9c6ca7345d1658cdd9723c8c9fd0d12" => :el_capitan
    sha256 "bc9c7469986602c65e7229c6bc8059ce0e133f507c873fc5e146bf27f2807ece" => :yosemite
  end

  depends_on "jam" => :build
  depends_on "jpeg"
  depends_on "libtiff"

  conflicts_with "num-utils", :because => "both install `average` binaries"

  def install
    system "sh", "makeall.sh"
    system "./makeinstall.sh"
    rm "bin/License.txt"
    prefix.install "bin", "ref", "doc"
  end

  test do
    system bin/"targen", "-d", "0", "test.ti1"
    system bin/"printtarg", testpath/"test.ti1"
    %w[test.ti1.ps test.ti1.ti1 test.ti1.ti2].each { |f| File.exist? f }
  end
end
