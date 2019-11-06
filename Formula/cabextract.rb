class Cabextract < Formula
  desc "Extract files from Microsoft cabinet files"
  homepage "https://www.cabextract.org.uk/"
  url "https://www.cabextract.org.uk/cabextract-1.9.1.tar.gz"
  sha256 "afc253673c8ef316b4d5c29cc4aa8445844bee14afffbe092ee9469405851ca7"

  bottle do
    cellar :any_skip_relocation
    sha256 "d60179c028ac5fb69580f2f01cd9f59c1d1544c8f6d84a230a7dd3587f3c27e0" => :catalina
    sha256 "cd27b939a0191d4dfff8ae13300b260b5ae01c563a21613718160012a982d5e8" => :mojave
    sha256 "c77caa7c32b4320f9e887abeea99261345e83f03e2c321ec9e99ddd9c75f5d98" => :high_sierra
    sha256 "c531546af69afda3101f07b509eb143cdaef00f4fdcbdd420e60287508a87e5e" => :sierra
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
