class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod2/pianod2-421.tar.gz"
  sha256 "760d2f013f6a8bf10993813f61a7929119470861351ba74d7add754e35c57d28"
  license "MIT"

  livecheck do
    url "https://deviousfish.com/Downloads/pianod2/"
    regex(/href=.*?pianod2[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "dce8f5d16200cfc55895051aa6b2a569e2766d781422ca2d3c257419f561b4d2"
    sha256 arm64_sequoia: "b587d434a5e1e0e7d3f1faf1858d8473dcf121dae6dd3a1f7142f0b0007f4854"
    sha256 arm64_sonoma:  "a68dc0e9431dafce94b251e12659d1e0eaf9f2a3617b5e752b92de8359310945"
    sha256 sonoma:        "fa9f904cabe5608b02357ac352f5926dd26bff5b58f4604ffc1e9244613005c4"
    sha256 arm64_linux:   "a6af473d6469828ed1426f869ebe6c82c8b1eee0156c76c4abdc35058c80fa66"
    sha256 x86_64_linux:  "28f080f5a6107f662ac30db93416586a5fb4bb881a847af2884e779896583c47"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gstreamer"
  depends_on "taglib"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libbsd"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"pianod", "-v"
  end
end
