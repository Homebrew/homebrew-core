class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https://github.com/containers/crun"
  url "https://github.com/containers/crun/releases/download/1.25/crun-1.25.tar.zst"
  sha256 "6ac556af87a56422c962554b082be430477be1f62a4d9ec44e0c4b7d54a6a386"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "0a03632e5234a98b28e05e052f08197cafcf9d81af59332c5aaa69fc63c81fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9cd4458dc30ae18ca0a46fea08641415666fa0363cf649dfc1cb993e066f0018"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "go-md2man" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build

  depends_on "libcap"
  depends_on "libseccomp"
  depends_on :linux
  depends_on "systemd"
  depends_on "yajl"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_empty shell_output("#{bin}/crun --root=#{testpath} list -q").strip
  end
end
