class Ponysay < Formula
  desc "Cowsay but with ponies"
  homepage "http://erkin.co/ponysay/"
  url "https://github.com/erkin/ponysay/archive/3.0.3.tar.gz"
  sha256 "c382d7f299fa63667d1a4469e1ffbf10b6813dcd29e861de6be55e56dc52b28a"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "8b0a41bbcbe4c68e41ac22105bce767571cf5692ed560c33f7c23a7cb4d8add0" => :high_sierra
    sha256 "23b0039eb56209d6d86cdb20bf73df14fc0e2c429a5989211c6592850d8048b2" => :sierra
    sha256 "a817eca399b8cd73a6ebef5906d9ae05703a1cec1f7680143718d31512b35993" => :el_capitan
  end

  depends_on "python"
  depends_on "coreutils"

  def install
    system "./setup.py",
           "--freedom=partial",
           "--prefix=#{prefix}",
           "--cache-dir=#{prefix}/var/cache",
           "--sysconf-dir=#{prefix}/etc",
           "install"
  end

  test do
    system "#{bin}/ponysay", "-A"
  end
end
