class Libselinux < Formula
  desc "SELinux library and simple utilities"
  homepage "https://github.com/SELinuxProject/selinux"
  url "https://github.com/SELinuxProject/selinux/releases/download/3.9/libselinux-3.9.tar.gz"
  sha256 "e7ee2c01dba64a0c35c9d7c9c0e06209d8186b325b0638a0d83f915cc3c101e8"
  license :public_domain

  livecheck do
    url :stable
    regex(/^libselinux[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "455ac9f48180d1ee022319db56c4aec5cdf130eafc3cc647b10230159688597e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5239cd516c3408456195f3922e76a447476eee220df3a03bb13be8de12d31bf7"
  end

  depends_on "pkgconf" => :build
  depends_on "libsepol"
  depends_on :linux
  depends_on "pcre2"

  def install
    system "make", "install", "PREFIX=#{prefix}", "SHLIBDIR=#{lib}"
  end

  test do
    assert_match(/^(Enforcing|Permissive|Disabled)$/, shell_output(sbin/"getenforce").chomp)
  end
end
