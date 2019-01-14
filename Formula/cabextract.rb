class Cabextract < Formula
  desc "Extract files from Microsoft cabinet files"
  homepage "https://www.cabextract.org.uk/"
  url "https://www.cabextract.org.uk/cabextract-1.9.tar.gz"
  sha256 "1bbc793d83c73288acd7e28ce33ec04955a76c73bf6471424ff835d725fcc4c1"

  bottle do
    cellar :any_skip_relocation
    sha256 "41b602b3d06f9414fd8d6b964b8735e345c133d51b2e12f52a1bc277083389b5" => :mojave
    sha256 "6f52b4c2e1debdcc2d5fa8d47c3678ec8dd703afc7c7b193596f1fe319eaa9cc" => :high_sierra
    sha256 "0fd78ce411d50aacad23db777441ae624977604036c2674b9eed24853ce13bca" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # probably the smallest valid .cab file
    cab = <<~EOS.gsub(/\s+/, "")
      4d5343460000000046000000000000002c000000000000000301010001000000d20400003
      e00000001000000000000000000000000003246899d200061000000000000000000
    EOS
    (testpath/"test.cab").binwrite [cab].pack("H*")

    system "#{bin}/cabextract", "test.cab"
    assert_predicate testpath/"a", :exist?
  end
end
