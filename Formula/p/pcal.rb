class Pcal < Formula
  desc "Generate Postscript calendars without X"
  homepage "https://pcal.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pcal/pcal/pcal-4.11.0/pcal-4.11.0.tgz"
  sha256 "8406190e7912082719262b71b63ee31a98face49aa52297db96cc0c970f8d207"
  license :cannot_represent

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f1e0e7b42a908bec8dcf41782a3e4b9397955a95a9c0781ef8e21fbf2ef8a327"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e9cb1a02b94bf537f5f1aab6ee035a1ade559ce499f53afabff16e0795b21868"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19b81c568f2c5aae1c0d148f8c9746f858613c11c2fb5196264f73297dbcb7b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d837d4b3cb7b1133b733c4c688a1d36ef7117fd5b9668e8c671a38f46f6ed9b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b4a76aed457b08622d910fadeacd998972ed4c16a9c2747fac5c26d4ecfbab4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdd9d437f60310691c6df93af1ee0bd2cc08e8bae5ee3fa1d73d76b76b4c88e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac1418d17450998bec7de62e86d71d0bc116cd4eb0ae45d5756d701ceecfa697"
    sha256 cellar: :any_skip_relocation, ventura:        "3c4d6d54cba50845f194e621e60a86d71f16712a1bf643eeff14cd669b08a7d1"
    sha256 cellar: :any_skip_relocation, monterey:       "8b780cbb1c7a72381be2baf453fc7f9f3940aa30e73608928682a2acf6266fab"
    sha256 cellar: :any_skip_relocation, big_sur:        "53c8157fa626298655248853dc283fe15947f47c725de2ea0c934773f0470063"
    sha256 cellar: :any_skip_relocation, catalina:       "9d7f46d2cbf308cd81bcce8fb98e48d295917562a46e509e739cad51d90dcf2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e8f41a9d2ac3d3944d6e0e64a4d502f9c317cfbd47ed8471c4b230b159a653d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4ca61c591e3d9f96352a2b83689f5dad406082f164eeb621602400aed315a9a"
  end

  uses_from_macos "mandoc" => :build
  uses_from_macos "ncompress" => :build

  def install
    # mandoc is only available since Ventura, but groff is available for older macOS
    inreplace "Makefile", /[gn]roff /, "mandoc " if !OS.mac? || MacOS.version >= :ventura

    ENV.deparallelize
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man1}",
                              "CATDIR=#{man}/cat1"
  end

  test do
    system bin/"pcal"
  end
end
