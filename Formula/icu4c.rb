class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "https://icu.unicode.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-72-1/icu4c-72_1-src.tgz"
  version "72.1"
  sha256 "a2d2d38217092a7ed56635e34467f92f976b370e20182ad325edea6681a71d68"
  license "ICU"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.gsub("-", ".") }.compact
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0666e999875e81eadd009af55007c95cda37c7234acc12eb85cf42177984c699"
    sha256 cellar: :any,                 arm64_monterey: "90c50fe2cbf8bedcae43886caaa096ab6fc54f893be192912220ba1ec48e634f"
    sha256 cellar: :any,                 arm64_big_sur:  "19575d7aa6e4451271cf20a9c455fc7f4a05103573879fa83d7b4625cffddcf5"
    sha256 cellar: :any,                 ventura:        "ecb91e87e3e4d075e3e1392b8ec7dc6774bec47f4b534d318f2ec259052b10e4"
    sha256 cellar: :any,                 monterey:       "ec1d2f2fe462d2cbe9775e48d5c4231af2b265f946de3902e0e042619c8ac205"
    sha256 cellar: :any,                 big_sur:        "899d9a8e7ab10896afad66a3d3c9053a5a10ae290b23197b1210c03bc0af6e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "880ba1731d14d66d48594a7ca1532b12ec50c1e2e3b6c7cd96cfaf05bab04d2f"
  end

  keg_only :provided_by_macos, "macOS provides libicucore.dylib (but nothing else)"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-samples
      --disable-tests
      --enable-static
      --with-library-bits=64
    ]

    cd "source" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    if File.exist? "/usr/share/dict/words"
      system "#{bin}/gendict", "--uchars", "/usr/share/dict/words", "dict"
    else
      (testpath/"hello").write "hello\nworld\n"
      system "#{bin}/gendict", "--uchars", "hello", "dict"
    end
  end
end
