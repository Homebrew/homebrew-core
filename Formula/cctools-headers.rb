# The system versions are too old to build ld64
class CctoolsHeaders < Formula
  desc "cctools headers via Apple"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/cctools/cctools-855.tar.gz"
  sha256 "751748ddf32c8ea84c175f32792721fa44424dad6acbf163f84f41e9617dbc58"

  bottle do
    cellar :any_skip_relocation
    sha256 "867d6edac7d3c9e0ebdec8cb97e4ec8e2e32a1cb894cc2f5d73e282e1fc1ed03" => :high_sierra
    sha256 "b30ece09a0ea68969de159ea1004f8bf7b764e0d1930acb199331c915494c8a7" => :sierra
    sha256 "ca835a4d93f50715875bc1ab323630f788e64a0573ac994a7e5d60c9b064268d" => :el_capitan
    sha256 "a8ada963317cade3c7ed5df84fdcd3251a8b31a0bb4835a78ae4375ee0624b4e" => :yosemite
    sha256 "ac7f685067262f3b1c4f843cab7ed4c83fc58a63bb57a8c5416428db0d6c7ddd" => :mavericks
  end

  keg_only :provided_by_macos

  resource "headers" do
    url "https://opensource.apple.com/tarballs/xnu/xnu-2422.90.20.tar.gz"
    sha256 "7bf3c6bc2f10b99e57b996631a7747b79d1e1684df719196db1e5c98a5585c23"
  end

  def install
    # only supports DSTROOT, not PREFIX
    inreplace "include/Makefile", "/usr/include", "/include"
    system "make", "installhdrs", "DSTROOT=#{prefix}", "RC_ProjectSourceVersion=#{version}"
    # installs some headers we don't need to DSTROOT/usr/local/include
    (prefix/"usr").rmtree

    # ld64 requires an updated mach/machine.h to build
    resource("headers").stage { (include/"mach").install "osfmk/mach/machine.h" }
  end
end
