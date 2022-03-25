class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.32.0.tar.gz"
  sha256 "1077052d4c4e848ac47d14f9b37754d46419aecbe8c9a07e1f869c914faf3216"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d0c869144ad74de97de38c78d54c24b22fdd5f25075fe6fe4c845203a5fcb913"
    sha256 cellar: :any,                 arm64_big_sur:  "e317566f85aa939cee30c614e37462cff9fbef889edb9b81762a315c0e9a618a"
    sha256 cellar: :any,                 monterey:       "52f3a10837dff3eb40bbdb1543b93af6bd6abd08dc8745d90cd7dea8aca9a569"
    sha256 cellar: :any,                 big_sur:        "ce93eb445df52e88c24c338bf7cdcbb6630af3b9988b9b30209ba1143b15f377"
    sha256 cellar: :any,                 catalina:       "a223f6e56e30e08610846ab97aef8c4218ff0ee6eb7849539e125ca193533fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "739f3c099dd8224601d36dc64e8a7611f0ab66bc307c24d8fffa2cad23b8d80d"
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
