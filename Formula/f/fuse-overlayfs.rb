class FuseOverlayfs < Formula
  desc "FUSE implementation for overlayfs"
  homepage "https://github.com/containers/fuse-overlayfs"
  url "https://github.com/containers/fuse-overlayfs/archive/refs/tags/v1.14.tar.gz"
  sha256 "0779d1ee8fbb6adb48df40e54efa9c608e1d7bbd844800a4c32c110d5fcbe9f2"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "a7f8cf5e1be7d7fd77a0035c39dc2b58df1119e5c6c8f9918e02b6384c0c6833"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "67b15525a3dff8d4db1bbd933ad061aa07ce3818ba310e52cdad0bc01748deea"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "libfuse"
  depends_on :linux

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    mkdir "lowerdir/a"
    mkdir "lowerdir/b"
    mkdir "up"
    mkdir "workdir"
    mkdir "merged"
    test_cmd = "fuse-overlayfs -o lowerdir=lowerdir/a:lowerdir/b,upperdir=up,workdir=workdir merged 2>&1"
    output = shell_output(test_cmd, 1)
    assert_match "fuse: device not found, try 'modprobe fuse' first", output
    assert_match "fuse-overlayfs: cannot mount: No such file or directory", output
  end
end
