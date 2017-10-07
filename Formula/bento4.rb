class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://github.com/axiomatic-systems/Bento4/archive/v1.5.1-620.tar.gz"
  version "1.5.1-620"
  sha256 "4511f9d28a5c11d6829b0a39597e0c5aa1cab08ccb281342635eb185bfdbdd95"

  bottle do
    cellar :any_skip_relocation
    sha256 "47f9acaeafb398c0ca8331417a5159d720fd6e8a58562135d6a15cdadb1ef5cb" => :high_sierra
    sha256 "c5737a870830329c54b4f22c1ce7aeaa77a9d6b17f187dc941a5ab8a427a20e0" => :sierra
    sha256 "7a3dbcda2e9dea4921567eac224358c56173a429a4dec13ced3eb07b1ab30871" => :el_capitan
  end

  conflicts_with "gpac", :because => "both install `mp42ts` binaries"

  def install
    cd "Build/Targets/any-gnu-gcc" do
      system "make", "AP4_BUILD_CONFIG=Release"
      bin.install Dir["Release/*"].select { |f| File.executable?(f) }
    end
  end

  test do
    system "#{bin}/mp4mux", "--track", test_fixtures("test.m4a"), "out.mp4"
    assert_predicate testpath/"out.mp4", :exist?, "Failed to create out.mp4!"
  end
end
