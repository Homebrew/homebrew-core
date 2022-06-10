class FuseOverlayfs < Formula
  desc "FUSE implementation for overlayfs"
  homepage "https://github.com/containers/fuse-overlayfs"
  url "https://github.com/containers/fuse-overlayfs/archive/refs/tags/v1.9.tar.gz"
  sha256 "6a2ff4cb3d32bdedb7986bcb0430ce8e5c44f0e3e71b8c7be558451032fc27f4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "88fd290dd644c2edfeb0ff3052ab9305aac93f42a16215a33d5e9e9bac71a708"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  depends_on "libfuse"
  depends_on :linux

  def install
    system "autoreconf", "-fis"
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
