class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.35.2.tar.gz"
  sha256 "4dfef54329e63d9772a9e1c36ac99bc41173b79963dc0d8235f2c32f4b9e078f"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "cf0064df4cbcd02a33f27f4e65336e8d704670dd5756bf286f212fae29c02b12"
    sha256 cellar: :any,                 arm64_sequoia: "8119dbda3ef01eb2ce8f0ef31ce29da9babefd7376f54d0f12850878440f1d8b"
    sha256 cellar: :any,                 arm64_sonoma:  "cac2f2b68ed2d7fdbcaeca6e3bf48b645f721db5e641dc47a2c9c7251f1fa6e5"
    sha256 cellar: :any,                 sonoma:        "5d264f8b1394bf88cac7403a15efe5c7fdfad6960fc95f712cc302f87a5ee849"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "825886321e6fd519a3ace69a1f9bdf518ae0e6800ba310055dc4752e9d908a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c0ee9fe8d295f5d1b82e750a7c2594361c59842341dbdd1a2acfe86c7714c32"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "linux-pam"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl@3"].opt_prefix}"
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
