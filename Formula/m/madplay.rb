class Madplay < Formula
  desc "MPEG Audio Decoder"
  homepage "https://www.underbit.com/products/mad/"
  url "https://downloads.sourceforge.net/project/mad/madplay/0.15.2b/madplay-0.15.2b.tar.gz"
  sha256 "5a79c7516ff7560dffc6a14399a389432bc619c905b13d3b73da22fa65acede0"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url :stable
    regex(%r{url=.*?/madplay[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "72e70d67702779f7e7afaf31037db5b66789f54396a574e1932f222ca3bac912"
    sha256 arm64_sequoia:  "ba09b6ca2c1a89b49f0df90e4d4330c7271dd39f11d35cf165cb26a9899a6584"
    sha256 arm64_sonoma:   "bb53d0d999f2179e53c438c9fbcfc1fa57a6dfb0a0e87b144fe8d9f5c91689de"
    sha256 arm64_ventura:  "544e014609eb4449054c2cb5ec02f550ec5ab3619e48faf881db9b71bf9a390b"
    sha256 arm64_monterey: "e66c7d9d05cd323ad4091b07d063ce9ea5d65dd86fbc06e78ac9316522710432"
    sha256 sonoma:         "719d4a1feb495f2c6f4f4e9e9e00689bdf4c4b21ad54add5d91ba97238fbd687"
    sha256 ventura:        "3ad559cb2e38b5b0719a29bade20758642ecfd89c1afb724557b65442ca31e65"
    sha256 monterey:       "0042b125f11f24d15a45f1b231f3ac2e3cda228c67a9ba0ddb1a3f8ceef336bd"
    sha256 arm64_linux:    "cc83e5325da519f92d3ea70ea21391bb1019435cc38b30fd6b13792e5db35abd"
    sha256 x86_64_linux:   "dcf38528c7c57f08ecc8e8ec764d8d7a4be39fb7cec6a37320bb5999cc495e17"
  end

  depends_on "libid3tag"
  depends_on "mad"

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/madplay/patch-audio_carbon.c"
    sha256 "380e1a5ee3357fef46baa9ba442705433e044ae9e37eece52c5146f56da75647"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --build=x86_64
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"madplay", "--version"
  end
end
