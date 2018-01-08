class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://github.com/axiomatic-systems/Bento4/archive/v1.5.1-622.tar.gz"
  version "1.5.1-622"
  sha256 "60492b9b644a2cfce7af3d82a6277e34d3e906221339cd54fcfae831fff0535d"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e7a5cb02a3dc91637782ed79380b98d4db0780b17981c341d3f5abb24f9cff0" => :high_sierra
    sha256 "32bc7e9d96a4d00277a4114f984125527ff44ae5094b33aa6c49948b4fbca3fd" => :sierra
    sha256 "9a764950286b76d905c030f2c5b3e39a4bf763ece1f6b6aca0b357a414206636" => :el_capitan
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
