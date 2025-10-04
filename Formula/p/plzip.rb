class Plzip < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/plzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.12.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/plzip/plzip-1.12.tar.gz"
  sha256 "50d71aad6fa154ad8c824279e86eade4bcf3bb4932d757d8f281ac09cfadae30"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/plzip/"
    regex(/href=.*?plzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6ba7db43465095e0bfb4b8a117f14bda8588fafc7dc605a2ada4035e81cfdb37"
    sha256 cellar: :any,                 arm64_sequoia: "fa68bcaa48dd0802050154c8d55a806cdb2438147002937446900a25f252d386"
    sha256 cellar: :any,                 arm64_sonoma:  "f1170578b9745c5eea571dbafe958f3fdcdf455e3e2e60a8e2ced6cb7bf0b1b4"
    sha256 cellar: :any,                 sonoma:        "c8ca22b92ad54aa1ead0e792d0f34731d24b288d18968ae47f31a136d994434d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8bc9d28a291384c6be41a8db706e57f5fe186d65fcab884ce351651e6439abf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1ca5446b35b910a59409dcde145db4957a80fcf1a65d6b5cb0903476070eb6b"
  end

  depends_on "lzlib"

  # `make check` fails with "(stdin): Not enough memory" since Apple Clang 1700 / LLVM Clang 18
  on_macos do
    depends_on "llvm@17" => :build if DevelopmentTools.clang_build_version >= 1700
  end

  def install
    args = ["--prefix=#{prefix}"]

    # `make check` fails with "(stdin): Not enough memory" since Apple Clang 1700 / LLVM Clang 18
    if ENV.compiler == :clang && DevelopmentTools.clang_build_version >= 1700
      ENV.append_to_cflags "-I#{Formula["lzlib"].opt_include}"
      args += %W[
        CC=#{Formula["llvm@17"].opt_bin}/clang
        CXX=#{Formula["llvm@17"].opt_bin}/clang++
        CXXFLAGS=#{ENV.cxxflags}
      ]
    end

    system "./configure", *args
    system "make"
    system "make", "check"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    text = "Hello Homebrew!"
    compressed = pipe_output("#{bin}/plzip -c", text)
    assert_equal text, pipe_output("#{bin}/plzip -d", compressed)
  end
end
