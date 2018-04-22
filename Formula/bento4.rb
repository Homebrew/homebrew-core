class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://github.com/axiomatic-systems/Bento4/archive/v1.5.1-623.tar.gz"
  version "1.5.1-623"
  sha256 "dc0b93bcd555bfdb2952c7a2118db45444519519d2a1c0ef81bd65853022823d"

  bottle do
    cellar :any_skip_relocation
    sha256 "30ddf23023c2e7b61e394f901dd208d2a03c401ac976e4cce39f964b63207002" => :high_sierra
    sha256 "5cf0bb87f9b9ea586195e77b1c2be9def077f0ff6ce560557e26854adb399133" => :sierra
    sha256 "90a727a6d6ab3d7c704ed744cff39ed0be5b7fb3a1643d2bec304472767de534" => :el_capitan
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
