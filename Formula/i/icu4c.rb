class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "https://icu.unicode.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-74-2/icu4c-74_2-src.tgz"
  version "74.2"
  sha256 "68db082212a96d6f53e35d60f47d38b962e9f9d207a74cfac78029ae8ff5e08c"
  license "ICU"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ec52c07656afec651345fb9d1ddc4557982de778ad38bdfe584bf910d49286da"
    sha256 cellar: :any,                 arm64_sonoma:   "3facc22a7821e01d93a38e371e377f13275299d518929222ed34c77a4f4a65d3"
    sha256 cellar: :any,                 arm64_ventura:  "3c707a483df52f58010f3ab48f14e6e875cd99aefbac58ed6abf67f59b0a58d8"
    sha256 cellar: :any,                 arm64_monterey: "014d11c8918c732dc17f4436d1946584ab42a443355f18096e6d6f3280390330"
    sha256 cellar: :any,                 sonoma:         "ac4fb9cc76372d8ad8dff5c740ff2b5b6287a5303de625dd865e7afccbfd6b70"
    sha256 cellar: :any,                 ventura:        "7c966c530b3e01f87be0c46e8969e1801fd7c0d9ad76a0736a6c7767cc87da94"
    sha256 cellar: :any,                 monterey:       "899c8988186ea890db0be552eea88bd94496cd4b84217febe89c9b84c9acab7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b881638861905a1a730cdd618966dfcb548685314d86addd1ad6d110ba88432"
  end

  keg_only :provided_by_macos, "macOS provides libicucore.dylib (but nothing else)"

  def install
    args = %w[
      --disable-samples
      --disable-tests
      --enable-static
      --with-library-bits=64
    ]

    cd "source" do
      system "./configure", *args, *std_configure_args
      system "make"
      system "make", "install"
    end
  end

  test do
    if File.exist? "/usr/share/dict/words"
      system bin/"gendict", "--uchars", "/usr/share/dict/words", "dict"
    else
      (testpath/"hello").write "hello\nworld\n"
      system bin/"gendict", "--uchars", "hello", "dict"
    end
  end
end
