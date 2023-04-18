class Duti < Formula
  desc "Select default apps for documents and URL schemes on macOS"
  homepage "https://github.com/moretension/duti/"
  url "https://github.com/moretension/duti/archive/duti-1.5.4.tar.gz"
  sha256 "3f8f599899a0c3b85549190417e4433502f97e332ce96cd8fa95c0a9adbe56de"
  license :public_domain
  revision 1
  head "https://github.com/moretension/duti.git", branch: "master"

  livecheck do
    url :stable
    regex(/^duti[._-]v?(\d+(?:[.-]\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "396053ac173f80066c3ea7df5f61d6dbda8ddd26e97e8e4d269b382588a1e9e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9705d9ebf9ef5540335039879ae743ba9d9e9805016d2202e313eb81d73eaec5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15989262f5c7d544de82b10e38834bddfd9ecf301289204524974a383c5bca09"
    sha256 cellar: :any_skip_relocation, ventura:        "cf7c2dc7ca5f80c72e318e387aac4b39ce096f407aa66d5a8a2f1d24e059665d"
    sha256 cellar: :any_skip_relocation, monterey:       "a61ba323531971eceed2a6b07d3da8c9aaa69254584098b79067cb3de22c2f69"
    sha256 cellar: :any_skip_relocation, big_sur:        "e959be16e48d745c3a3e6faf168e9fbb0ee11d4c2a287e5d51b62042d06fbcb5"
    sha256 cellar: :any_skip_relocation, catalina:       "f162733347f2fa2218de556706632fd60ead9f750f8118db189a4db298b83d75"
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

  # Fix compilation on Ventura
  patch do
    url "https://github.com/moretension/duti/commit/54a1539b23ac764b32679bcada5659fbad483ecc.patch?full_index=1"
    sha256 "055023ce50903ffe9378c68d630a105d317b7efe778c029e3fe23521be89176f"
  end
  patch do
    url "https://github.com/moretension/duti/commit/8d31a2f75fefb61381dc7731cf7ecac9237ee64d.patch?full_index=1"
    sha256 "5987230901e63e619bba85c026201dd00ca3f06016a87516e031eebb6cf0e582"
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
