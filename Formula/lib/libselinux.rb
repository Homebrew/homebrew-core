class Libselinux < Formula
  desc "SELinux library and simple utilities"
  homepage "https://github.com/SELinuxProject/selinux"
  url "https://github.com/SELinuxProject/selinux/releases/download/3.10/libselinux-3.10.tar.gz"
  sha256 "1ef216c5b56fb7e0a51cd2909787a175a17ee391e0467894807873539ebe766b"
  license :public_domain

  livecheck do
    url :stable
    regex(/^libselinux[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "7c6593d704ae69111347086fc1737b3b951bcf6d262356c76e7867a5a1be5e2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c169a95f3fd4e549145c18114f4c0c4f3c9c51886d41b4ae66b6041cf486a156"
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
