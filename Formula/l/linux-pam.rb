class LinuxPam < Formula
  desc "Pluggable Authentication Modules for Linux"
  homepage "https://github.com/linux-pam/linux-pam"
  url "https://github.com/linux-pam/linux-pam/releases/download/v1.7.3/Linux-PAM-1.7.3.tar.xz"
  sha256 "2ce4765fd49df6693771ef2941f81e33d8ee14b94a81a5c7b369aa3b137b85a5"
  license any_of: ["BSD-3-Clause", "GPL-1.0-only"]
  compatibility_version 1
  head "https://github.com/linux-pam/linux-pam.git", branch: "master"

  bottle do
    sha256 arm64_linux:  "1b1ee1c55ac3aa9ddcf51eb00fde23982106d7da5124bb2bb3729c693e528f68"
    sha256 x86_64_linux: "5b9c7fd6a89d4b214a47fc950263eb7d49af426db375cd14e95bbaaaea6eef2e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libnsl"
  depends_on "libtirpc"
  depends_on "libxcrypt"
  depends_on :linux

  def install
    system "meson", "setup", "build", "--sysconfdir=#{etc}", "-Dvendordir=#{pkgshare}/security",
"-Dsecuredir=#{lib}/security", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "Usage: #{sbin}/mkhomedir_helper <username>",
                 shell_output("#{sbin}/mkhomedir_helper 2>&1", 14)
  end
end
