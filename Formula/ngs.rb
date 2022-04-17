class Ngs < Formula
  desc "Powerful programming language and shell designed specifically for Ops"
  homepage "https://ngs-lang.org/"
  url "https://github.com/ngs-lang/ngs/archive/v0.2.14.tar.gz"
  sha256 "9432377548ef76c57918b020b2abb258137703ff0172016d58d713186fcafed3"
  license "GPL-3.0-only"
  head "https://github.com/ngs-lang/ngs.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1ef58ca0af08ba7b8e30568dc89329ca2d7dde56b1f617c7ea761e648d5943ff"
    sha256 cellar: :any,                 arm64_big_sur:  "479155bbdc08c74555033cb3399499e8a483dca09eb317d9f0440a040f35941d"
    sha256 cellar: :any,                 monterey:       "c2d37bb8bf811e88ef63b977c15983f9ef7ca5111e91e5a9e1433a41b487ec22"
    sha256 cellar: :any,                 big_sur:        "8fc41ede0fb6966d1825eb40db7eb4b51e1e87adab1b53d2104581da18abd6b8"
    sha256 cellar: :any,                 catalina:       "020d1e3143db15da54baa7e0a01be63e238ba5f6aec3b11ed7dd69c5651679d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "358aff5f12a275ad72cb474f000ce798c5af3d529c3573af69fdadda0098c257"
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
