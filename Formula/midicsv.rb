class Midicsv < Formula
  desc "Convert MIDI audio files to human-readable CSV format"
  homepage "https://www.fourmilab.ch/webtools/midicsv/"
  url "https://www.fourmilab.ch/webtools/midicsv/midicsv-1.1.tar.gz"
  sha256 "7c5a749ab5c4ebac4bd7361df0af65892f380245be57c838e08ec6e4ac9870ef"

  livecheck do
    url :homepage
    regex(/href=.*?midicsv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfc81631f34a7b6c244c9c0381b46f24da59332e10770501232a2cdcc564601c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92dfc5dc808b233c4fbcf4b69a4f74f24c5d69ec409e687d716ddb04eeb78a45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4786091a3131f6ffafe70a561bc2a0ffcbab3ed7c651393bb1908e1bd00bad7"
    sha256 cellar: :any_skip_relocation, ventura:        "e78e37dd91b60d40dc8aa27a2d897b625a1e4c866681f4a54aea088c401b1acc"
    sha256 cellar: :any_skip_relocation, monterey:       "5efa2f2fd0083a02275769715699af018f8949db77910ede750505da0600dad3"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8d8481f70097bfa3d933af56c22f74891906cba93dc3952aad2a7f3f56b6feb"
    sha256 cellar: :any_skip_relocation, catalina:       "5d36fed687c5f4b23c0705ff261a798697bcda5d4fefa6d86d6a1449ad1efa50"
    sha256 cellar: :any_skip_relocation, mojave:         "3fcfcbe9f5b248c681f57eccd4c17c2f93d1a977c3a19949cbeee6dd77038787"
    sha256 cellar: :any_skip_relocation, high_sierra:    "737ea2eda70a778d076568af902f16d609aaae4baeb7ada7795c32d4de886f81"
    sha256 cellar: :any_skip_relocation, sierra:         "314a21ac6aaad39594a54bae4bf3ecc64e3ef0cd655e7c18c6ff05ebd72c9b86"
    sha256 cellar: :any_skip_relocation, el_capitan:     "230ba9ec9cbb40c2c128c1a063152fd07888210f59bf37f1f68bcd2f33d4d863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "683cf72afc59037843aed1da2bf95b0ba3927d8521aabcbc96702329bebf4ee4"
  end

  def install
    system "make"
    system "make", "check"
    system "make", "install", "INSTALL_DEST=#{prefix}"
    share.install prefix/"man"
  end

  test do
    system "#{bin}/midicsv", "-u"
  end
end
