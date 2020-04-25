class E2tools < Formula
  desc "Utilities to read, write, and manipulate files in ext2/3/4 filesystems"
  homepage "https://e2tools.github.io/"
  url "https://github.com/e2tools/e2tools/releases/download/v0.1.0/e2tools-0.1.0.tar.gz"
  sha256 "c1a06b5ae2cbddb6f04d070e889b8bebf87015b8585889999452ce9846122edf"

  bottle do
    cellar :any_skip_relocation
    sha256 "816825094314cfb451c177fb3f3f6956f3918db125b043bdf6e19aa7c404dc36" => :catalina
    sha256 "bf9b142f5bb6ba58710bdc077a181ba8a0ac593a46d5f5c9ff2a50d69a43bd78" => :mojave
    sha256 "7a782af6e3883fe9badda9b579193be4068b71fc1c2c8530f6b207b30bd1f9c3" => :high_sierra
    sha256 "5818dc7acdcb57aa0945c79280e118cd630ec45d0c3b1997c791158bf5c807e1" => :sierra
    sha256 "058158b36410bb749abe3bce7476a7f1c837417a38e8d3fa1dd54924df2d80a7" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "e2fsprogs"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system Formula["e2fsprogs"].opt_sbin/"mkfs.ext2", "test.raw", "1024"
    assert_match "lost+found", shell_output("#{bin}/e2ls test.raw")
  end
end
