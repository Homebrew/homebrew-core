class Clpbar < Formula
  desc "Command-line progress bar"
  homepage "https://clpbar.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/clpbar/clpbar/bar-1.11.1/bar_1.11.1.tar.gz"
  sha256 "fa0f5ec5c8400316c2f4debdc6cdcb80e186e668c2e4471df4fec7bfcd626503"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d00ea5044914b14d7e7c901eac63641085496b6fd474c9491e46109c6599709" => :mojave
    sha256 "eb3648e3cc14ab0712c6a71d3df6eab53bd66bad86a402df1716df3db09c0358" => :high_sierra
    sha256 "769dbb64e877ab1f52a496063bbfdac32911f38e6e25b4fc70a5cfe937923f5f" => :sierra
    sha256 "b54fa0ce24de6dda141e3fc025b67f2e0216b01a3664ec5992a98f8087881ddd" => :el_capitan
    sha256 "edaa21e4d80bbf174e3c040d3c786eb48e381ca8e9477dfbafb06b4ec0bfd19f" => :yosemite
    sha256 "36f1ece44bec7c54d2235fbfba5122d3a3d0430532498dc5c35601a59f9c4616" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--program-prefix='clp'"
    system "make", "install"
  end

  test do
    output = shell_output("dd if=/dev/zero bs=1024 count=5 | #{bin}/clpbar 2>&1")
    assert_match "Copied: 5120B (5.0KB)", output
  end
end
