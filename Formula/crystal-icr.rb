class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.5.0.tar.gz"
  sha256 "f2b5cb971b368085e9c4f607d906e0622aa94d65c0f7c820d9cbdf23fb972c33"
  revision 2

  bottle do
    sha256 "5702c04b7d3993c304367a4e57adda68967f49d8c00cd5861712c44cfd416f1a" => :high_sierra
    sha256 "c71458325b064cd1062be74b0d8ceadccb9e76c70f272d464f4461884b2745d2" => :sierra
    sha256 "b0ecff4280242c2d91aa2bdb383fbbb60f682522b42ded34286c0b55616b2494" => :el_capitan
  end

  depends_on "crystal-lang"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
