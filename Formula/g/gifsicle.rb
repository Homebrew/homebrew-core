class Gifsicle < Formula
  desc "GIF image/animation creator/editor"
  homepage "https://www.lcdf.org/gifsicle/"
  url "https://www.lcdf.org/gifsicle/gifsicle-1.99.tar.gz"
  sha256 "c21a01f670a336f5412b1870e5a6c241252a3408a3e699d216d58bd41011ae06"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?gifsicle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "fb3a5d9205146722959321994ac175dad92f40f9761f7ce0def8aa9689ad6192"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "781a2d0a3d95784484d0b10275a0cd8a8af132cbff69c0bde6b1bc32d5167a09"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ac5a2d2dfabb906b29910d0c0e0997f376f183f22e2c9ed7a805ecf14044c30e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "59dfbc7caad15df714eebf76c0ae06a2175d979481b7fe7e14fff360bebcbb06"
    sha256 cellar: :any,                 arm64_linux:       "2cf0e3e524eb457c3042f131f7ccf6790a46cf41ec36e6fccd7991c3e9b7b316"
    sha256 cellar: :any,                 x86_64_linux:      "bbb56c40e2d5863747366d232e759370afee00d03343fc58122c5c6e4c9d9a22"
  end

  head do
    url "https://github.com/kohler/gifsicle.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  deny_network_access!

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-gifview
    ]

    system "./bootstrap.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"gifsicle", "--info", test_fixtures("test.gif")
  end
end
