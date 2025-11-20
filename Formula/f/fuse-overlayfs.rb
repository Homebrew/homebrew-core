class FuseOverlayfs < Formula
  desc "FUSE implementation for overlayfs"
  homepage "https://github.com/containers/fuse-overlayfs"
  url "https://github.com/containers/fuse-overlayfs/archive/refs/tags/v1.16.tar.gz"
  sha256 "45968517603389ead067222d234bc8d8ed33e4b4f8ba16216bdd3e6aedcccea9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "f56b8eaeddb077f80c3742194033850eeb11f2c9eb266cd317ba02879a49dc90"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a3163181e6457cc906550f2f5f71473820eaec8bc4f658dd3475caa39ed033c4"
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
