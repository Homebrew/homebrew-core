class Bwctl < Formula
  desc "Command-line tool and daemon for network measuring tools"
  homepage "https://software.internet2.edu/bwctl/"
  url "https://software.internet2.edu/sources/bwctl/bwctl-1.5.4.tar.gz"
  sha256 "e6dca6ca30c8ef4d68e6b34b011a9ff7eff3aba4a84efc19d96e3675182e40ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "fbde1025f5c75ec448c07252cdaea22bcc62fa6f1247c46631c8400045bc4083" => :mojave
    sha256 "6b2ff7de11ab2b22180d8f59349b403f74c5d5321c60e44cb1f493fa25a5e786" => :high_sierra
    sha256 "23f32c2e2b5203c4b4fecfb33e2152e5d732305e60ef5b02e4bbf1a9f7355c73" => :sierra
    sha256 "ac9e615919ebd84515022f9650f42194d9ad4b1c1f5f97509e1293962a96e943" => :el_capitan
    sha256 "c8890647536e60b3ed8599eb3239ee59fde0382e9df8b7585ee7eeb20275fc39" => :yosemite
    sha256 "f10efbf8f41f526130340cc6087ce3dfad83b71b69d21e0b01c11b3169d88bdd" => :mavericks
    sha256 "b60c679e8b498ffc23e697cb025dc6decc4f4d939e2b0874ff36291967eee18d" => :mountain_lion
  end

  depends_on "i2util" => :build

  def install
    # configure mis-sets CFLAGS for I2util
    # https://lists.internet2.edu/sympa/arc/perfsonar-user/2015-04/msg00016.html
    # https://github.com/Homebrew/homebrew/pull/38212
    inreplace "configure", 'CFLAGS="-I$I2util_dir/include $CFLAGS"', 'CFLAGS="-I$with_I2util/include $CFLAGS"'

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-I2util=#{Formula["i2util"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/bwctl", "-V"
  end
end
