class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://github.com/axiomatic-systems/Bento4/archive/v1.5.0-616.tar.gz"
  version "1.5.0-616"
  sha256 "b68d78c4e067bdd853176d469894d330f3268725842639af5edfe4977f04dc54"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2557099c48cbfd1388bdf4d8565f20fd4086379a92e026241bb8dafcd7fed9b" => :sierra
    sha256 "9035175de1a18684bab726253be87d6d95c105ca63bce813c9584e820ce05fe9" => :el_capitan
    sha256 "9ecb3ddb0e70de5564214a0675bb24a480e82a2d36fc64297386eda922f3b163" => :yosemite
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
