class Cabextract < Formula
  desc "Extract files from Microsoft cabinet files"
  homepage "https://www.cabextract.org.uk/"
  url "https://www.cabextract.org.uk/cabextract-1.9.1.tar.gz"
  sha256 "afc253673c8ef316b4d5c29cc4aa8445844bee14afffbe092ee9469405851ca7"
  license "GPL-3.0"

  livecheck do
    url :homepage
    regex(/href=.*?cabextract[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b76f71d383733860f6d81d72a38f3d0fb07c28d6fb72d7261b19c5973482853"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f421b4d93548f37080a4041a1ae83cffa6e0407489913ea09525e3e3f482d39e"
    sha256 cellar: :any_skip_relocation, monterey:       "293895188547de1614324e2830e80f7605ee63b0c8019961e413a8c11c4e2fb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ddac23f5e64926d1f2cd400e6fa0739db93dc0517712965b2b0ca1b3e74eabd"
    sha256 cellar: :any_skip_relocation, catalina:       "d60179c028ac5fb69580f2f01cd9f59c1d1544c8f6d84a230a7dd3587f3c27e0"
    sha256 cellar: :any_skip_relocation, mojave:         "cd27b939a0191d4dfff8ae13300b260b5ae01c563a21613718160012a982d5e8"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c77caa7c32b4320f9e887abeea99261345e83f03e2c321ec9e99ddd9c75f5d98"
    sha256 cellar: :any_skip_relocation, sierra:         "c531546af69afda3101f07b509eb143cdaef00f4fdcbdd420e60287508a87e5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a5504109fb1efe70b9d92f53cb617486f9036597ca77c606ff71d9e4b373f4b"
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
