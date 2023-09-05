class Dvorak7min < Formula
  desc "Dvorak (simplified keyboard layout) typing tutor"
  homepage "https://web.archive.org/web/dvorak7min.sourcearchive.com/"
  url "https://deb.debian.org/debian/pool/main/d/dvorak7min/dvorak7min_1.6.1+repack.orig.tar.gz"
  version "1.6.1"
  sha256 "4cdef8e4c8c74c28dacd185d1062bfa752a58447772627aded9ac0c87a3b8797"
  license "GPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f581243f32da61dd063a2ef9c4e8c2297b4bd556f7905d4a520009a8bf865b73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f38e077e0ee68158e8b287d8bf9b679378cfb03a496afd2049f9b36e840ba2c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb028aa9707f685095023a20694b713e9adaa2f4ade7adc95b483f54d2775a6e"
    sha256 cellar: :any_skip_relocation, ventura:        "b4eeacfb1b35f5498fb7f77da6b513109a87a54d686a62a6c221a08aab9a8178"
    sha256 cellar: :any_skip_relocation, monterey:       "cbf598fe212330ed130813b5a7ac1be0f31ea98b7aa3e12559371bdc35217356"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e42924b5dd8704ca4fa6d70b7c966c3956268ebf78ef5fc2022fdee3c1ed82b"
    sha256 cellar: :any_skip_relocation, catalina:       "b8f692d9254375715d1f85af32ce5b7487802597818f2bb969b3cac109d3012a"
    sha256 cellar: :any_skip_relocation, mojave:         "2657090fcb79b647e9c805780eb2a90d6a875aee6aebeb2dc0eebbdd3ace3ed1"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0cfad9ea53f984ebc81c87fe2bd7fd8f3bad6c8c0032085de36eb499b041b5b0"
    sha256 cellar: :any_skip_relocation, sierra:         "052c259da37d2e9576fdf1809ce526dd54cedd362bbe747f02fa088e6568983b"
    sha256 cellar: :any_skip_relocation, el_capitan:     "d4bf1a053028f0712193e33911c2af3fb4f0a71b37480969b5c03b798d4930ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88198e60fed089e8dcc4c8bb9fb955428cecd480578fd1a339e177b1c1e748df"
  end

  uses_from_macos "ncurses"

  def install
    # Remove pre-built ELF binary first
    system "make", "clean"
    system "make"
    system "make", "INSTALL=#{bin}", "install"
  end
end
