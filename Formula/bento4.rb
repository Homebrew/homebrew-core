class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://github.com/axiomatic-systems/Bento4/archive/v1.5.1-622.tar.gz"
  version "1.5.1-622"
  sha256 "60492b9b644a2cfce7af3d82a6277e34d3e906221339cd54fcfae831fff0535d"

  bottle do
    cellar :any_skip_relocation
    sha256 "c144ec1b23c260a6e6e6877e06fc83d1e770eb1bb4cdef8395519ca0bcd9605c" => :high_sierra
    sha256 "df1e97c429bdc9b040ad016bf100f4ebe65208478e01d44a32a8375d909dabf5" => :sierra
    sha256 "2c2bd127d09f36e6bda52794abb8afb8a8d335e6d19de5758867b73a14f43957" => :el_capitan
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
