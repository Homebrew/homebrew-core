class Duti < Formula
  desc "Select default apps for documents and URL schemes on macOS"
  homepage "https://github.com/moretension/duti/"
  url "https://github.com/moretension/duti/archive/duti-1.5.4.tar.gz"
  sha256 "3f8f599899a0c3b85549190417e4433502f97e332ce96cd8fa95c0a9adbe56de"
  license :public_domain
  revision 1
  head "https://github.com/moretension/duti.git"

  livecheck do
    url :stable
    regex(/^duti[._-]v?(\d+(?:[.-]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff0b636a4b54edf70502d88e26b04281ee3d25cea64fea0b2ea8421b5fe26f47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7ba0f6fd9de2bd9f853883027edcb480b7cf12c7a2076aa87226efc239d5578"
    sha256 cellar: :any_skip_relocation, monterey:       "417b9103060e5a555852dcb76a2b921359ef9153a532cc27e8dda0b74c9cc7c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2e0ccdd5be1c9f272787bc96ed419df33ef4199b47bb8a0762af596d3fc442b"
    sha256 cellar: :any_skip_relocation, catalina:       "5fe04375afd229149721ce8a0cd66fe7a372fa5a5dce11084616d2a979aa47fe"
    sha256 cellar: :any_skip_relocation, mojave:         "ffb23db168b014703e505ef2d76d7bc431efd5d4d1244833d9b2ddf5723133a6"
    sha256 cellar: :any_skip_relocation, high_sierra:    "e495d02894655b516f79fa10671f5d768cae04c5b73c1aa077f8b0c573584cbf"
  end

  depends_on "autoconf" => :build
  depends_on :macos

  # Fix compilation on macOS 10.14 Mojave
  patch do
    url "https://github.com/moretension/duti/commit/825b5e6a92770611b000ebdd6e3d3ef8f47f1c47.patch?full_index=1"
    sha256 "0f6013b156b79aa498881f951172bcd1ceac53807c061f95c5252a8d6df2a21a"
  end

  # Fix compilation on macOS >= 10.15
  patch do
    url "https://github.com/moretension/duti/commit/4a1f54faf29af4f125134aef3a47cfe05c7755ff.patch?full_index=1"
    sha256 "7c90efd1606438f419ac2fa668c587f2a63ce20673c600ed0c45046fd8b14ea6"
  end

  # Fix compilation on Monterey
  patch do
    url "https://github.com/moretension/duti/commit/ec195e261f8a48a1a18e262a2b1f0ef26a0bc1ee.patch?full_index=1"
    sha256 "dec21aeea7f31c1a2122a01b44c13539af48840b181a80cecb4653591a9b0f9d"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "com.apple.TextEdit", shell_output("#{bin}/duti -l public.text"),
                 "TextEdit not found among the handlers for public.text"
  end
end
