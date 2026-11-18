class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-6.1.0.tar.gz"
  sha256 "c28406dc922e64560095ec3ec99feb8eddd3f96e7b6eed22309a5865d1eab226"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b231ed64c1d5daa9be71f7c29684dd2e93722fe2dfdbe203a4cba76296b64b34"
    sha256 cellar: :any, arm64_tahoe:       "94a5a3097c18bda882bfe30ff4e1e9f385d137d38668084a881fbd62c9135194"
    sha256 cellar: :any, arm64_sequoia:     "fbeb133a4ad05f74feed815d1f6d4de6cdc31ee595baebf5de5b411245d42690"
    sha256 cellar: :any, arm64_linux:       "df1a0dc75c6d61d6816c2381b3351670ebda1cf0fb6f716cf1d8ef5e16c6fa25"
    sha256 cellar: :any, x86_64_linux:      "d5150f33bc3ffa43d404e90ea606464a24c84d08b5afd9f873f0396aa6c3d27d"
  end

  depends_on "openssl@4"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "linux-pam"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{dep("openssl").opt_prefix}"
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
