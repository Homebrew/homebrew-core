class Acme < Formula
  desc "Crossassembler for multiple environments"
  homepage "https://sourceforge.net/projects/acme-crossass/"
  url "https://github.com/UffeJakobsen/acme/archive/d2683cc64dcb1afc643388100b14e575f8bfb1bd.tar.gz"
  version "0.97"
  sha256 "efda4ca8db9811e28e4604d25b5941888c949c175d1b47e40610c90a7b74a73d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://sourceforge.net/p/acme-crossass/code-0/HEAD/tree/trunk/docs/Changes.txt?format=raw"
    regex(/New in release v?(\d+(?:\.\d+)+)/i)
    strategy :page_match
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e894feb9110a2f6f251217c1f344f9bf8159709fa1334ad2c53d6434780e13c7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "baf7f67a658cfa338c79f0884da06949c43734cb2ad8864b40075337b9800a8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "45e4bdc0da9f4cf88bd8be0ea4c3967d11c11a4a56071beb0e9dc72506336319"
    sha256 cellar: :any,                 arm64_linux:       "309dc221f897b20bbf039c091bd0ce2e0aa417f3234812d7910ddd58d85e85fc"
    sha256 cellar: :any,                 x86_64_linux:      "d0821b518d6eb85209ad08ae73a4cfb13a611d4cc65fdd4092102712a9837a06"
  end

  # Last release on 2020-07-10 with only binary distribution.
  # Most repositories (Arch, Debian, FreeBSD, nixpkgs, etc.) have moved
  # to following SVN revisions but not supported in Homebrew
  deprecate! date: "2026-10-17", because: "does not have a checksummed source"
  disable! date: "2027-04-17", because: "does not have a checksummed source"

  deny_network_access!

  def install
    system "make", "-C", "src", "install", "BINDIR=#{bin}"
    doc.install Dir["docs/*"]
  end

  test do
    path = testpath/"a.asm"
    path.write <<~ASM
      !to "a.out", cbm
      * = $c000
      jmp $fce2
    ASM

    system bin/"acme", path
    code = File.open(testpath/"a.out", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0x00, 0xc0, 0x4c, 0xe2, 0xfc], code
  end
end
