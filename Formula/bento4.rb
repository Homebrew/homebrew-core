class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://github.com/axiomatic-systems/Bento4/archive/v1.5.0-618.tar.gz"
  version "1.5.0-618"
  sha256 "7dfb9200f36b252aeb39eb179e3e2e1f3c44600b4dc8ef654a80da26abcb9ade"

  bottle do
    cellar :any_skip_relocation
    sha256 "925bab204eafc0bd5d0e2e66bfabc36c17eddeeb37791b351b9aaaae6aa8cbcf" => :sierra
    sha256 "b2af29f03b7a76793f79e28cb41463dcdb427b8928cf418bc5082b7f715b1972" => :el_capitan
    sha256 "29ecb03408175958464787f5f0f25dfe2b874e29fd04a221ccd6991ba9b72fa7" => :yosemite
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
