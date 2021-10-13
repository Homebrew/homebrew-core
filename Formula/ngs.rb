class Ngs < Formula
  desc "Powerful programming language and shell designed specifically for Ops"
  homepage "https://ngs-lang.org/"
  url "https://github.com/ngs-lang/ngs/archive/v0.2.12.tar.gz"
  sha256 "bd3f3b7cca4a36150405f26bb9bcc2fb41d0149388d3051472f159072485f962"
  license "GPL-3.0-only"
  head "https://github.com/ngs-lang/ngs.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "fc20adda0f39a4e22d54081c55b3299dced4078c96f5e7869d1903ac66c843ea"
    sha256 cellar: :any,                 big_sur:       "f92d46bbd5c75caadce87ba7856fd49367cdeae26f94f9875cad7bc3f87187db"
    sha256 cellar: :any,                 catalina:      "56844fed9b44e5d1cca3634051245eb43f6758f995e1a0ffd8b919e17df51510"
    sha256 cellar: :any,                 mojave:        "d5d04636b7d4a6de1028fedbe36fe15c1938d7dd5d5e09a9bfda0680e39d17ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90df083108ebf23aeda5ab859a96cc901e43ee53d0f1962f3869de1c3c3df9ea"
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
