class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2024.86.tar.bz2"
  sha256 "e78936dffc395f2e0db099321d6be659190966b99712b55c530dd0a1822e0a5e"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?dropbear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e29395a023ddb759271d39c25e8d617ba5c4289e58fea0209b7271566c4c2e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "017e16888e6f0d05adbade2eee8ac8fa380ed4d47cf3dbb14a139f8274e98bdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86fb52679bb14e9b71bccc1e1fa720bbd66d30d8c8799f21cf4ab2ab978687a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "001918a57d55adfc29571bb1344a5fd4872e2b05ba0b1bb2ee640c40ecb48c81"
    sha256 cellar: :any_skip_relocation, ventura:       "2f9dd80d129c81a4169499b49e5492e9f20ecd783cc39a02b6ef1e4d2f0c75d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e27cd4a21c7a4f699ca726bb5d8b5220acb47258e86eca69e5580ea7d0501d6d"
  end

  head do
    url "https://github.com/mkj/dropbear.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    ENV.deparallelize

    if build.head?
      system "autoconf"
      system "autoheader"
    end
    system "./configure", "--prefix=#{prefix}",
                          "--enable-pam",
                          "--enable-zlib",
                          "--enable-bundled-libtom",
                          "--sysconfdir=#{etc}/dropbear"
    system "make"
    system "make", "install"
  end

  test do
    testfile = testpath/"testec521"
    system bin/"dbclient", "-h"
    system bin/"dropbearkey", "-t", "ecdsa", "-f", testfile, "-s", "521"
    assert_predicate testfile, :exist?
  end
end
