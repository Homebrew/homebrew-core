class Libowfat < Formula
  desc "Reimplements libdjb"
  homepage "https://www.fefe.de/libowfat/"
  url "https://www.fefe.de/libowfat/libowfat-0.32.tar.xz"
  sha256 "f4b9b3d9922dc25bc93adedf9e9ff8ddbebaf623f14c8e7a5f2301bfef7998c1"
  license "GPL-2.0-only"
  revision 1
  head ":pserver:cvs:@cvs.fefe.de:/cvs", using: :cvs

  livecheck do
    url :homepage
    regex(/href=.*?libowfat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65db99117a336254a90e1da30635af40c430bbedb569ff6bc1d4f0fb85714d4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f136abc75d88d46768041ce1e32344905a3cc66179734785011ed001acda8db"
    sha256 cellar: :any_skip_relocation, monterey:       "8e1e0c82e8977146f0b880c578c282bba56590cb70c64050c4a665b10c2cf6f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5fcc5eed33299becabcd1144074b6971730d7edbacea54b22f0ed5c723a09bf"
    sha256 cellar: :any_skip_relocation, catalina:       "9fd957c443aa34237004dbcce7254377b164262df39bb3ba7ea8a8f1d70f5f59"
    sha256 cellar: :any_skip_relocation, mojave:         "2b1cffc2e679e98801f576358d42fb3b7217187f2551f5fe4460f5b29ffd485c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed6b06c82988da9cee1f3d4fc9f9e7b180fcf656cb1e508237b3cfe225257770"
  end

  patch do
    url "https://github.com/mistydemeo/libowfat/commit/278a675a6984e5c202eee9f7e36cda2ae5da658d.patch?full_index=1"
    sha256 "32eab2348f495f483f7cd34ffd7543bd619f312b7094a4b55be9436af89dd341"
  end

  def install
    system "make", "libowfat.a"
    system "make", "install", "prefix=#{prefix}", "MAN3DIR=#{man3}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libowfat/str.h>
      int main()
      {
        return str_diff("a", "a");
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lowfat", "-o", "test"
    system "./test"
  end
end
