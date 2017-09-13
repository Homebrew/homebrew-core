class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V1.9.2_src.zip"
  version "1.9.2"
  sha256 "4d61ae0b91686dea721d34df2e44eaf36c88da87086fd50ccc4e999a58e9ce90"
  revision 2

  bottle do
    cellar :any
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
    %w[test.ti1.ps test.ti1.ti1 test.ti1.ti2].each { |f| File.exist? f }
    assert_match "Calibrate a Display", shell_output("#{bin}/dispcal 2>&1", 1)
  end
end
