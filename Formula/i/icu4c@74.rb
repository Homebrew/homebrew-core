class Icu4cAT74 < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "https://icu.unicode.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-74-2/icu4c-74_2-src.tgz"
  version "74.2"
  sha256 "68db082212a96d6f53e35d60f47d38b962e9f9d207a74cfac78029ae8ff5e08c"
  license "ICU"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d9b0dc95a406d340373bf75d6d013cc53e8815d0c0b550e584b4006a7aba12f0"
    sha256 cellar: :any,                 arm64_sonoma:  "2216fec75032a12c4a442448ca23fed421eb94374e2e9994e6db0c51eae60ed2"
    sha256 cellar: :any,                 arm64_ventura: "1870714606c1792b9ca84cb9c07028c745575c8f3219c629f56c27b1b333ce25"
    sha256 cellar: :any,                 sonoma:        "715c3ec07d1056f609f7b670fa6b8767aa508d4e8e4f93b2ae15a635b77715c4"
    sha256 cellar: :any,                 ventura:       "81c9ad51d30a5b4d33c4b2a1c89d46d27bc4e6c8f1ffe8f723bf2c8d1bb27901"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13a2717a6454f814a899079cc2276e062b839b19ef5be9c026efb289c3d93775"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99595c8a778c7b3161baed663fb738a28213e9e31797aa558f6c5bb5ab239c3d"
  end

  keg_only :versioned_formula

  disable! date: "2025-05-01", because: :versioned_formula

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
