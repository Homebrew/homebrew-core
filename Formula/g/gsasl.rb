class Gsasl < Formula
  desc "SASL library command-line interface"
  homepage "https://www.gnu.org/software/gsasl/"
  url "https://ftpmirror.gnu.org/gnu/gsasl/gsasl-2.2.4.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gsasl/gsasl-2.2.4.tar.gz"
  sha256 "d32be15efd3a04cb19b232f721bdca02cc6ad7ab415df7d79fb2dd2c0da3e0be"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "86c631a0bf8ffaa3d5ba42389213f65d21ffc71f0e049feb848dc5052c2b27b0"
    sha256 arm64_sequoia: "9a25d22998eeba013f34cd1b50e53aa2c2931468c7dadf83d973a3e17423d2a4"
    sha256 arm64_sonoma:  "107ece8328df9aeddfb928ee7fbf6b34606945392b2d6abbed06b37220c28f61"
    sha256 sonoma:        "05a6b0cad1e9a800c8a195931492f877a3c7089cd603e3d0145439da3c80394d"
    sha256 arm64_linux:   "ce1e2b689168efb31c32654f8c5e8339cf6f439ec4faf1aeb5655d1c4fbbc699"
    sha256 x86_64_linux:  "eec4ac0d2d24e1d4ffb9934920b899bb2761b2b443215131663d4a50c13bffeb"
  end

  depends_on "libgcrypt"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--with-gssapi-impl=mit", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsasl --version")
  end
end
