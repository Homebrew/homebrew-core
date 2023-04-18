class Ngs < Formula
  desc "Powerful programming language and shell designed specifically for Ops"
  homepage "https://ngs-lang.org/"
  url "https://github.com/ngs-lang/ngs/archive/v0.2.15.tar.gz"
  sha256 "552db7230db858aef7731c4dd31e3d862b5943cb47216e47f59b8dee1de67fe8"
  license "GPL-3.0-only"
  head "https://github.com/ngs-lang/ngs.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2527ab3e1b8b4db1744be388e3f6644495636b797652ecb895c212da5f4a3c62"
    sha256 cellar: :any,                 arm64_monterey: "cb5257d54b5587480f67d2e593b366a754ca22617ce9c68631b20334a583b066"
    sha256 cellar: :any,                 arm64_big_sur:  "e4089e908f058fca3ba576795698b1793bcadcc3cb7de8c1d9c625deeb665b4a"
    sha256 cellar: :any,                 ventura:        "3a12816791215075769c8309a06e6d6a5a27704ab9b848d1df3658eda87840b9"
    sha256 cellar: :any,                 monterey:       "dea3af55d05668816864f4a49536ab09f4d6849ba28da52bf142465c356a422e"
    sha256 cellar: :any,                 big_sur:        "0348b79d22c9a0cb5fd985ef5a26d44b2ea3e4447021c1e92cd6043bff3c577d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd6620cb3018d88afaa0be4c101ef175e66c24e86b726a951192f7e7e3d03e81"
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
