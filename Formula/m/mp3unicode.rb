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

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "805642379132c96276425ef190cc0bcfde0ef174a8ec5770bac012161a8f38f7"
    sha256 cellar: :any,                 arm64_sonoma:  "b6434c7943edf0cd5cecaba2b555f0ec952c13092e56449f01ee3abd34579633"
    sha256 cellar: :any,                 arm64_ventura: "bebb09ce30735cc1bddb24b9470f1b07e203405c035f590a4302c6afdbbc1a0a"
    sha256 cellar: :any,                 sonoma:        "eb03f9111f1e15d3876c862ea20356838e695baa922328f51892809dbead2443"
    sha256 cellar: :any,                 ventura:       "515babceaa10d361c09079bc4810fedff9542ed526ee84d3feb448ee8d60175d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f652c90bd61d95a3926b6ffc9ed41169d315e94006924a34c680e79db7f092af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b8357a98b0f7229b16cbcd8c1463ff8f5c27f12f31747c0adee5b9d4b663c47"
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
