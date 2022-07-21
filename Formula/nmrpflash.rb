class Nmrpflash < Formula
  desc "Netgear Unbrick Utility"
  homepage "https://github.com/jclehner/nmrpflash"
  url "https://github.com/jclehner/nmrpflash/archive/refs/tags/v0.9.18.2.tar.gz"
  sha256 "ba0afe584bf45567fc8156773554a2365b85c0ffbbdc322bfeda6f8c18674029"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64c3929054ec6839db99b907b0d3865a8e6badaf052d4bfa20d8d450aa0c62af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ebefeb746a23c129a75ea2d5c2822130d07cefcc8e73e0c960a1515ec26a20e"
    sha256 cellar: :any_skip_relocation, monterey:       "d44c9093cbb445d103fc6d0723025d63cbd7022466391947f690b3bad5bd6d7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "905356f3c6d611332b0710823a93ff3b5debd3caeacd6499302d38eb19dffac7"
    sha256 cellar: :any_skip_relocation, catalina:       "466479b0ea911ebc840f083ac323d9696474e3ecf5b27975a020869cb4dc95f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05bca795880fb69c0de775621c23b908c53b0a5e70d209ce508693735d07ef01"
  end

  uses_from_macos "libpcap"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libnl"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "VERSION=#{version}"
  end

  test do
    system bin/"nmrpflash", "-L"
  end
end
