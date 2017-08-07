class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V1.9.2_src.zip"
  version "1.9.2"
  sha256 "4d61ae0b91686dea721d34df2e44eaf36c88da87086fd50ccc4e999a58e9ce90"
  revision 1

  bottle do
    cellar :any
    sha256 "71312f762d52aecd4bf01a3e4ea58b1ab55737265930fa8d3bbccea041a3f422" => :sierra
    sha256 "9a43b16c4dfc07eb339c8cc66e7d46d035f0d8f62b2e6a4786cb6a842e1e3a29" => :el_capitan
    sha256 "cf832c6ba07b9ca60102a087b08c7469f785094cd612d20ca8ae269298687154" => :yosemite
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
