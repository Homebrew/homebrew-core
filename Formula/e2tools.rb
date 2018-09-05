class E2tools < Formula
  desc "Utilities to read, write, and manipulate files in ext2/3/4 filesystems"
  homepage "http://home.earthlink.net/~k_sheff/sw/e2tools/"
  url "http://home.earthlink.net/~k_sheff/sw/e2tools/e2tools-0.0.16.tar.gz"
  sha256 "4e3c8e17786ccc03fc9fb4145724edf332bb50e1b3c91b6f33e0e3a54861949b"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf9b142f5bb6ba58710bdc077a181ba8a0ac593a46d5f5c9ff2a50d69a43bd78" => :mojave
    sha256 "7a782af6e3883fe9badda9b579193be4068b71fc1c2c8530f6b207b30bd1f9c3" => :high_sierra
    sha256 "5818dc7acdcb57aa0945c79280e118cd630ec45d0c3b1997c791158bf5c807e1" => :sierra
    sha256 "058158b36410bb749abe3bce7476a7f1c837417a38e8d3fa1dd54924df2d80a7" => :el_capitan
  end

  depends_on "e2fsprogs"

  def install
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
