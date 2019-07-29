class Cmix < Formula
  desc "Data compression program with high compression ratio"
  homepage "https://www.byronknoll.com/cmix.html"
  url "https://github.com/byronknoll/cmix/archive/v17.tar.gz"
  version "17.0.0"
  sha256 "31af51dd0be70c9c3c724911b60a46c11860e9fabb59860d541c869966a84c46"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d0853a7359422d21f3fa77d0130f979cb88a36418be3f767d59f10958403100" => :mojave
    sha256 "7b9b9850f26bc23078d4a4321d129e4e82f14db885d1609b9ac916047170b106" => :high_sierra
    sha256 "da16b7d8acc398c4ac59f89dc27f2ae1d4ba4391c8c8bbd3e841c236f201e497" => :sierra
  end

  def install
    system "make"
    bin.install "cmix"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/cmix", "-c", "foo", "foo.cmix"
    system "#{bin}/cmix", "-d", "foo.cmix", "foo.unpacked"
    assert_equal "test", shell_output("cat foo.unpacked")
  end
end
