class FuseOverlayfs < Formula
  desc "FUSE implementation for overlayfs"
  homepage "https://github.com/containers/fuse-overlayfs"
  url "https://github.com/containers/fuse-overlayfs/archive/refs/tags/v1.17.tar.gz"
  sha256 "cefffecfbb001b2784f19af344f27eae07b31a4faa38d345b738af96b2bec59e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_linux:  "2984a4e1dea792d2d0687b9435af67f6c4724fc1caedecdf577330bdc83d7a02"
    sha256 cellar: :any, x86_64_linux: "7574002cc6c46fffb2c793e0a3f1310c53d9d62ebdea119669b6979f6e3cef93"
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
    assert_match "fuse: device /dev/fuse not found. Kernel module not loaded?", output
    assert_match "fuse-overlayfs: cannot mount: No such file or directory", output
  end
end
