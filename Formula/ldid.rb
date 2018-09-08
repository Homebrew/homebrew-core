class Ldid < Formula
  desc "Lets you manipulate the signature block in a Mach-O binary"
  homepage "https://cydia.saurik.com/info/ldid/"
  url "https://git.saurik.com/ldid.git",
      :tag => "v1.2.1",
      :revision => "e4b7adc1e02c9f0e16cc9ae2841192b386f6d4ea"
  head "https://git.saurik.com/ldid.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4e49148184ab10923e0d84a27476b2dd71a48d076a5424c266a012e0d7749f27" => :mojave
    sha256 "2bf739a0271fc467fc18e26d9dd6bb54d824173af0cd45d466aeef3a37031c1b" => :high_sierra
    sha256 "a10adbb230ad11abdb044006e740b2bb33023a998b111c62e99aa69d8dad4839" => :sierra
    sha256 "a10adbb230ad11abdb044006e740b2bb33023a998b111c62e99aa69d8dad4839" => :el_capitan
    sha256 "fda9d5608ad5e6446ed8fd7b3135d8407fc44b88f628dd4c19391738bd57bf6c" => :yosemite
  end

  depends_on "openssl"

  def install
    inreplace "make.sh" do |s|
      s.gsub! %r{^.*/Applications/Xcode-5.1.1.app.*}, ""

      # Reported upstream 2 Sep 2018 (to saurik via email)
      s.gsub! "-mmacosx-version-min=10.4", "-mmacosx-version-min=#{MacOS.version}"
      s.gsub! "for arch in i386 x86_64; do", "for arch in x86_64; do" if MacOS.version >= :mojave
    end
    system "./make.sh"
    bin.install "ldid"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main(int argc, char **argv) { return 0; }
    EOS

    system ENV.cc, "test.c", "-o", "test"
    system bin/"ldid", "-S", "test"
  end
end
