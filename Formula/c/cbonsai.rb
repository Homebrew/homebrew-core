class Cbonsai < Formula
  desc "Console Bonsai is a bonsai tree generator, written in C using ncurses"
  homepage "https://gitlab.com/jallbrit/cbonsai"
  url "https://gitlab.com/jallbrit/cbonsai/-/archive/v1.4.2/cbonsai-v1.4.2.tar.gz"
  sha256 "75cf844940e5ef825a74f2d5b1551fe81883551b600fecd00748c6aa325f5ab0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "37e1bd7792b0722a35a28ac8e248d711f23ece8fc43fcfacfddcd8fa72db9f94"
    sha256 cellar: :any,                 arm64_sequoia: "869d5f9329619e9bc7fafd702f44e2f3725cde753cc0c4b8653599b70153d0c1"
    sha256 cellar: :any,                 arm64_sonoma:  "71feed554a3774e5ded7a663fc43519ef0a9c633805495464326a0d078feed8c"
    sha256 cellar: :any,                 arm64_ventura: "75af3e2e01e01d53c62a195d5f9f43d30f799a8126c342e668201dddcea5022b"
    sha256 cellar: :any,                 sonoma:        "2ec9072aa232ecf1242b783d7db8b61023532e28e1a11789dc9f49fdd185bc9d"
    sha256 cellar: :any,                 ventura:       "c9ce84ec6ca012fb023bd5648e585660ca47aaa525686aba6c2404ff22580a91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5607d8b16bcd0d2f736cef0014baeef29eeec6fed5ffa98bbf017728d0d62a92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b8bee402d858d1ade576595f3e0727f3f65bfab1b9a500c7de7a08fe861c935"
  end

  depends_on "pkgconf" => :build
  depends_on "scdoc" => :build
  depends_on "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"cbonsai", "-p"
  end
end
