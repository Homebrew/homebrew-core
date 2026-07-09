class Libselinux < Formula
  desc "SELinux library and simple utilities"
  homepage "https://github.com/SELinuxProject/selinux"
  url "https://github.com/SELinuxProject/selinux/releases/download/3.11/libselinux-3.11.tar.gz"
  sha256 "73d419c6e20e874adaa4019372cbd097eecf4d276e13f27ec5e67d35c0bd203c"
  license :public_domain

  livecheck do
    url :stable
    regex(/^libselinux[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "c997ac2e0dde0159775d383a9a40aa9dea9449d1076963b7a046263ed09bcad7"
    sha256 cellar: :any, x86_64_linux: "1249c10e7d9e630a71a252d7988d2f5bffa0144174e5c80ff705b89470ec0968"
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
