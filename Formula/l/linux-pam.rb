class LinuxPam < Formula
  desc "Pluggable Authentication Modules for Linux"
  homepage "https://github.com/linux-pam/linux-pam"
  url "https://github.com/linux-pam/linux-pam/releases/download/v1.7.1/Linux-PAM-1.7.1.tar.xz"
  sha256 "21dbcec6e01dd578f14789eac9024a18941e6f2702a05cf91b28c232eeb26ab0"
  license any_of: ["BSD-3-Clause", "GPL-1.0-only"]
  head "https://github.com/linux-pam/linux-pam.git", branch: "master"

  bottle do
    sha256 arm64_linux:  "812e0552fe6776b29595e17ddb8a132cb58078cb6be4d53df40526b41e8e5058"
    sha256 x86_64_linux: "0019c338480af392377bbb270fef3329e2542b1956d8b9b9c5068ffcc8480f54"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libnsl"
  depends_on "libtirpc"
  depends_on "libxcrypt"
  depends_on :linux

  def install
    system "meson", "setup", "build", "--sysconfdir=#{etc}", "-Dsecuredir=#{lib}/security", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "Usage: #{sbin}/mkhomedir_helper <username>",
                 shell_output("#{sbin}/mkhomedir_helper 2>&1", 14)
  end
end
