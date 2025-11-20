class Mp3unicode < Formula
  desc "Command-line utility to convert mp3 tags between different encodings"
  homepage "https://mp3unicode.sourceforge.net/"
  license "GPL-2.0-only"

  stable do
    url "https://github.com/alonbl/mp3unicode/releases/download/mp3unicode-1.2.1/mp3unicode-1.2.1.tar.bz2"
    sha256 "375b432ce784407e74fceb055d115bf83b1bd04a83b95256171e1a36e00cfe07"

    # Backport support for taglib 2
    patch do
      url "https://github.com/alonbl/mp3unicode/commit/a4958c3b5cbfd7464a2d05f5212c0eb21ddf7210.patch?full_index=1"
      sha256 "7cdaf35bb09b5d4ee9c3ef4703bed415ed9df8be5e64f06dc7b4654739e58ab4"
    end
  end

  livecheck do
    url :stable
    regex(/^mp3unicode-v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "75d5fc48faf45713ba932224204b1a5334a4f0aff1955c22913fa40238d457cd"
    sha256 cellar: :any,                 arm64_sequoia: "b0f39474b3f41688794f00e4815e40a6aa792614610870d4ec1377d5a67ed5c7"
    sha256 cellar: :any,                 arm64_sonoma:  "54f458d22e3d58242645a99c9c3a3b90c013fb815ddca51775469bb4c04fe2d8"
    sha256 cellar: :any,                 arm64_ventura: "7b7678aef37dc84509ae7918c2ab3288bb8daff100402b3d820802dc778fccb0"
    sha256 cellar: :any,                 sonoma:        "81dcda2481711046268ce10a1980298d3ea38e3c3c94bba92bf510d2e4fc62e0"
    sha256 cellar: :any,                 ventura:       "cf53f60a18ca4821fd4c242efce17a6424aa44a4e413de27e60463d6846540b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54bfbaee2ebfdcef4e35e69cf8b9224e477b357d449e2badd94580014e0682e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4360c1dd812097207ccf5ba329d8cf1082e152a78fba69a8f1273c29ac0bb89f"
  end

  head do
    url "https://github.com/alonbl/mp3unicode.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "taglib"

  def install
    ENV.append "ICONV_LIBS", "-liconv" if OS.mac?
    ENV.append "CXXFLAGS", "-std=c++17"

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"mp3unicode", "-s", "ASCII", "-w", test_fixtures("test.mp3")
  end
end
