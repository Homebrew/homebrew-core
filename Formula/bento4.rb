class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://github.com/axiomatic-systems/Bento4/archive/v1.5.0-619.tar.gz"
  version "1.5.0-619"
  sha256 "29f0561e52c2aedb719c97a49449297037ead133bc67346fa1c083570cc5c058"

  bottle do
    cellar :any_skip_relocation
    sha256 "d787cb4572295b9f28af0b1adb928526b5119dd0ed59cb756180264614db63b1" => :high_sierra
    sha256 "f0c08300eecef32c759169ad70d1eec5d6c6cbb5fd1adb57fa2059baaca974bb" => :sierra
    sha256 "ca87f6c11a24d18d09fc87d96b0c67e5ee43516468432126cca79ac091005b4b" => :el_capitan
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
