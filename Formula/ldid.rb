class Ldid < Formula
  desc "Lets you manipulate the signature block in a Mach-O binary"
  homepage "https://cydia.saurik.com/info/ldid/"
  url "git://git.saurik.com/ldid.git",
    :tag => "v1.2.1",
    :revision => "e4b7adc1e02c9f0e16cc9ae2841192b386f6d4ea"

  head "git://git.saurik.com/ldid.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a10adbb230ad11abdb044006e740b2bb33023a998b111c62e99aa69d8dad4839" => :sierra
    sha256 "a10adbb230ad11abdb044006e740b2bb33023a998b111c62e99aa69d8dad4839" => :el_capitan
    sha256 "fda9d5608ad5e6446ed8fd7b3135d8407fc44b88f628dd4c19391738bd57bf6c" => :yosemite
  end

  depends_on "openssl"

  def install
    inreplace "./make.sh", %r{^.*/Applications/Xcode-5.1.1.app.*}, ""
    system "./make.sh"
    bin.install "ldid"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      int main(int argc, char **argv) { return 0; }
    EOS

    system ENV.cc, "test.c", "-o", "test"
    system bin/"ldid", "-S", "test"
  end
end
