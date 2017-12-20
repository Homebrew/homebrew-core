class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V2.0.0_src.zip"
  version "2.0.0"
  sha256 "5492896c040b406892864c467466ad6b50eb62954b5874ef0eb9174d1764ff41"

  bottle do
    cellar :any
    sha256 "616119b8561e35bac3d64f501194b9aa4a8318406df7c85d23d548e78baa2dcc" => :high_sierra
    sha256 "20f26b082601be3c18620f150aa1307d2d7627c0d4b44835967e33f03d1e6377" => :sierra
    sha256 "e8fbfefa41768db1e223155f2547e9b0054bf2ff32673f0b77e9c4d6949771f8" => :el_capitan
    sha256 "ce291dee7fc76f43ec0c8fe4ab28e6195fb862fe8fa204b06b515d5a1a5759e4" => :yosemite
  end

  depends_on "jam" => :build
  depends_on "jpeg"
  depends_on "libtiff"

  conflicts_with "num-utils", :because => "both install `average` binaries"

  def install
    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # Reported 20 Aug 2017 to graeme AT argyllcms DOT com
    if MacOS.version == :el_capitan && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace "numlib/numsup.c", "CLOCK_MONOTONIC", "UNDEFINED_GIBBERISH"
    end

    system "sh", "makeall.sh"
    system "./makeinstall.sh"
    rm "bin/License.txt"
    prefix.install "bin", "ref", "doc"
  end

  test do
    system bin/"targen", "-d", "0", "test.ti1"
    system bin/"printtarg", testpath/"test.ti1"
    %w[test.ti1.ps test.ti1.ti1 test.ti1.ti2].each do |f|
      assert_predicate testpath/f, :exist?
    end
    assert_match "Calibrate a Display", shell_output("#{bin}/dispcal 2>&1", 1)
  end
end
