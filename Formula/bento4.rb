class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://github.com/axiomatic-systems/Bento4/archive/v1.5.0-619.tar.gz"
  version "1.5.0-619"
  sha256 "29f0561e52c2aedb719c97a49449297037ead133bc67346fa1c083570cc5c058"

  bottle do
    cellar :any_skip_relocation
    sha256 "508efcd868dbca5fb8c0c097d13f20b468e2e85936e6148e66247b8ae283d01b" => :high_sierra
    sha256 "8bb6a41d88fa6c21e5d6ac86482aa232986cf7bd8298ec525e4640b5aab81cc7" => :sierra
    sha256 "c5e4cdb5623d116bb302f179040286337ba34a8a0a1906f6e26ee95aa57ee9ee" => :el_capitan
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
