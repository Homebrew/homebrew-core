class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.16.0.tar.gz"
  sha256 "050e871db3b603227ccccf34db570656fcc6df2140262afd5f2d129a180ba8bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "220df71f5d6fef514ea26d6a6aab1fb1e2efe7505d7740fdcee8fae244400bd1" => :catalina
    sha256 "10459980fc6171b950f8b3e8fdfde23d43e6e2026f784c4cb3c921e11c521ad8" => :mojave
    sha256 "b737d735cb01287a2bf265ba2984974bef552f863475fdc2a439155c305eba47" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
