class ExVi < Formula
  desc "UTF8-friendly version of tradition vi"
  homepage "https://ex-vi.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ex-vi/ex-vi/050325/ex-050325.tar.bz2"
  sha256 "da4be7cf67e94572463b19e56850aa36dc4e39eb0d933d3688fe8574bb632409"

  livecheck do
    url :stable
    regex(%r{url=.*?/ex[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "690982e02183d89a46a976131577092a48155ae8e80b9aad89440e7baad51959"
    sha256 arm64_big_sur:  "b5d40f595021f02eb45114157e2e62718b8ee1066ed90d1f4e05ba39f4aa1859"
    sha256 monterey:       "205fe1e5548f4f8b8f357e85f2a1729dc60a12e62669e9c7dd56c4299f2168d9"
    sha256 big_sur:        "8cbdb5b3f60cec0b0b7dcfb9c11c06d159428b5d1c24a1b889fcf470839ff024"
    sha256 catalina:       "843fceed3514fe1506e32619c15c092441d45d553a809b315f38e1b749623492"
    sha256 mojave:         "112fa443488e178fd67fe600de3e56ad40179e8aeb73314c1286cea827df3220"
    sha256 high_sierra:    "63c5da327ae066a381dab232102b82621379c70c700949b5dc31d87b3dd56f75"
    sha256 sierra:         "2719bdb0715bd327745b0b4c6829492115336314a921d0b66f2f1a2609c949b0"
    sha256 el_capitan:     "e3f68edff7a526463ae6a217b9292c2a6025489df848372abe777da141be14ef"
    sha256 yosemite:       "6e3195cd61b05a482e13162a5559ca90d65b1805b8559c006ffc960b56cbe935"
  end

  uses_from_macos "ncurses"

  conflicts_with "vim",
    because: "ex-vi and vim both install bin/ex and bin/view"

  def install
    system "make", "install", "INSTALL=/usr/bin/install",
                              "PREFIX=#{prefix}",
                              "PRESERVEDIR=/var/tmp/vi.recover",
                              "TERMLIB=ncurses"
  end
end
