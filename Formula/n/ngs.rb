class Ngs < Formula
  desc "Powerful programming language and shell designed specifically for Ops"
  homepage "https://ngs-lang.org/"
  url "https://github.com/ngs-lang/ngs/archive/refs/tags/v0.2.16.tar.gz"
  sha256 "282bcd00164044a01b025b5373ed2e0b03d6e5b3d04cea2f363629a7ea5b92c7"
  license "GPL-3.0-only"
  head "https://github.com/ngs-lang/ngs.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "708e581c7e0699872b3d4bda635cf3f88a669b563c016fd9bd912a9f0cb548ca"
    sha256 cellar: :any,                 arm64_sonoma:   "3dc53e9e67cb000b4c98e40caabe6a04f7d7a6a54933d66e42414b8376d7885e"
    sha256 cellar: :any,                 arm64_ventura:  "3674f32e36e9540344f785353d6320d202b6c438b7b0684fbdfddb5728eb738f"
    sha256 cellar: :any,                 arm64_monterey: "8774017f7b51b5781c980beef4cf66a0db98bfdca9c0a9a7838f76b8174d0a33"
    sha256 cellar: :any,                 arm64_big_sur:  "e0b61a48a78a8d4157760cc14d349f9175732c27a994946593b07affd2de270a"
    sha256 cellar: :any,                 sonoma:         "ddfd6270de4f01541bca4f1b98a4d693ee92d942998154ad46484e02fa2bef59"
    sha256 cellar: :any,                 ventura:        "34e76b7ffed6d7c220c20badd232c3d6dfd1c26a6d5c3705f487dcaa1c9cd8c1"
    sha256 cellar: :any,                 monterey:       "f10b6a267dab0fac7684445365906decc3543b7291d6f0c3c353ad4b429349c8"
    sha256 cellar: :any,                 big_sur:        "56ac0599b463715236eb73b04708c58fd9d3bd9cf3bbbf6dbd4938145fb315f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08dc0db6f45cc3c8c9690a9626b4b1f75a289cfc28f79d12dfd832783fccd492"
  end

  depends_on "cmake" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "gnu-sed"
  depends_on "json-c"
  depends_on "pcre"
  depends_on "peg"

  uses_from_macos "libffi"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    share.install prefix/"man" unless OS.mac?
  end

  test do
    assert_match "Hello World!", shell_output("#{bin}/ngs -e 'echo(\"Hello World!\")'")
  end
end
