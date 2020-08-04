class Duti < Formula
  desc "Select default apps for documents and URL schemes on macOS"
  homepage "https://github.com/moretension/duti/"
  url "https://github.com/moretension/duti/archive/duti-1.5.4.tar.gz"
  sha256 "3f8f599899a0c3b85549190417e4433502f97e332ce96cd8fa95c0a9adbe56de"
  license "Unlicense"
  revision 1
  head "https://github.com/moretension/duti.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5fe04375afd229149721ce8a0cd66fe7a372fa5a5dce11084616d2a979aa47fe" => :catalina
    sha256 "ffb23db168b014703e505ef2d76d7bc431efd5d4d1244833d9b2ddf5723133a6" => :mojave
    sha256 "e495d02894655b516f79fa10671f5d768cae04c5b73c1aa077f8b0c573584cbf" => :high_sierra
  end

  depends_on "autoconf" => :build

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

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "com.apple.TextEdit", shell_output("#{bin}/duti -l public.text"),
                 "TextEdit not found among the handlers for public.text"
  end
end
