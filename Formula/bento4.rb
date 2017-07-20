class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://github.com/axiomatic-systems/Bento4/archive/v1.5.0-615.tar.gz"
  version "1.5.0-615"
  sha256 "109d48b75e7ba34d5a0cb98346c098d9e0d29d58b6bc27b90014dbc558a491a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8804fd92f0b384287b762dbb7b5ceb9f6f98c4859ad3d62abd0857e02f65448" => :sierra
    sha256 "436e5973c42b9b788fa431e51b5b04d6acc4a91ff015a070a35e308e23db323e" => :el_capitan
    sha256 "bdc17a166e54cface41c9e16227c1d18800fcd077f9c8d4fbb0cd111653856ec" => :yosemite
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
