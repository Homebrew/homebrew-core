class Duti < Formula
  desc "Select default apps for documents and URL schemes on macOS"
  homepage "https://github.com/moretension/duti/"
  url "https://github.com/moretension/duti/archive/duti-1.5.4.tar.gz"
  sha256 "3f8f599899a0c3b85549190417e4433502f97e332ce96cd8fa95c0a9adbe56de"
  revision 1
  head "https://github.com/moretension/duti.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e327eda2392f8a4cc6f05f14848c118d680996ecb065af2f44d05461c2c63e2f" => :mojave
    sha256 "61d2281c0c477d98203e6d85c83f7ccb76dddcc86f81a316d2a83df4cef4a64b" => :high_sierra
    sha256 "e0178ad9c0f9a10120cc78ff63bbe727f8fc42fb3ed03438593f21381f8bdb3c" => :sierra
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
