class Ngs < Formula
  desc "Powerful programming language and shell designed specifically for Ops"
  homepage "https://ngs-lang.org/"
  url "https://github.com/ngs-lang/ngs/archive/v0.2.12.tar.gz"
  sha256 "bd3f3b7cca4a36150405f26bb9bcc2fb41d0149388d3051472f159072485f962"
  license "GPL-3.0"
  head "https://github.com/ngs-lang/ngs.git"

  bottle do
    sha256 cellar: :any, big_sur:  "0c479302f362f5a29d560cb329fdd23f661029ad21ca572aa77bae7d4d6329ca"
    sha256 cellar: :any, catalina: "d7635955a01a24e1873b3f2b525cb23a1ad0053210da2a651bf04c4a66bc593c"
    sha256 cellar: :any, mojave:   "f4592f29a531af5e177e3e3c4f823f61f74101524f52794771bc3c841661b4b2"
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
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    share.install prefix/"man"
  end

  test do
    assert_match "Hello World!", shell_output("#{bin}/ngs -e 'echo(\"Hello World!\")'")
  end
end
