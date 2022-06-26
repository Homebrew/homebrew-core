class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.32.0.tar.gz"
  sha256 "1077052d4c4e848ac47d14f9b37754d46419aecbe8c9a07e1f869c914faf3216"
  license "AGPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "21eb3d11227e8bda20795b418f8f355b5694a363e0f8b8694d2559475f2d7421"
    sha256 cellar: :any,                 arm64_big_sur:  "aa19c34d3170a64dc8c825ea17f20c2a7f5b622b6344a0fe6b7e6a8a725a4733"
    sha256 cellar: :any,                 monterey:       "0224a3b0547aac17b806f2c7a7039dc69c4b4189e58f7738861f5fb853a2d10c"
    sha256 cellar: :any,                 big_sur:        "a6ed1f2d8263769e3796f296a108656f07e854887f4ac648d0f69711a44699f0"
    sha256 cellar: :any,                 catalina:       "76e57e50992213d7f62dc6d33e622013f4252bb2ebb99f1c0dacb89898d04fe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa1e9ac3c7c0c129debf80185f30ec4b8dcea96a392649edd46f7bea7188b6f4"
  end

  depends_on "openssl@1.1"

  uses_from_macos "libxcrypt"

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
