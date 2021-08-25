class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.28.0.tar.gz"
  sha256 "9fc6287fd9570b25a85c5d5bf988ee8bd4c54d0e9e01ff04cc4b9398a159849c"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_big_sur: "8899ed8eb91d13a2033ec97c60d1df0344110b177a88a10e7fb09d9f5fb51712"
    sha256 cellar: :any,                 big_sur:       "87816b1850bfa853ba312933fdaa0af656f9ecc18cc4a420f58fae9e659d6d55"
    sha256 cellar: :any,                 catalina:      "07be9b5e3c46d314cbdcffc239c275f98a5fa1ac9f1161d1cd2d1e21fdb44a16"
    sha256 cellar: :any,                 mojave:        "5952392c467ab1b0286c9fe977e962089afc479e92e067a22008f4d742014b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bce1b68d5ce46516c73147927dc386d1a91155fc81fa3dbd06d1379089061aef"
  end

  depends_on "openssl@1.1"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl@1.1"].opt_prefix}"
    system "make"
    system "make", "install"
    etc.install "monitrc"
  end

  service do
    run [opt_bin/"monit", "-I", "-c", etc/"monitrc"]
  end

  test do
    system bin/"monit", "-c", "#{etc}/monitrc", "-t"
  end
end
