class Ngs < Formula
  desc "Powerful programming language and shell designed specifically for Ops"
  homepage "https://ngs-lang.org/"
  url "https://github.com/ngs-lang/ngs/archive/v0.2.14.tar.gz"
  sha256 "9432377548ef76c57918b020b2abb258137703ff0172016d58d713186fcafed3"
  license "GPL-3.0-only"
  head "https://github.com/ngs-lang/ngs.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7ac61b5c9438473a5f71c38284858266792591132258e22a49430aa15d06e25d"
    sha256 cellar: :any,                 arm64_big_sur:  "b41e5bc67f4f5bf5a3ccc4d84e59e89097da7e425c3b17417fcb09f064edfbb3"
    sha256 cellar: :any,                 ventura:        "3a31458abfb58d69d6c1faf9527b294b7fafd017242787db5d74a8fb8b89271c"
    sha256 cellar: :any,                 monterey:       "2a233c86f9388f3a867954b702e0291ac348c0203f3a343e8b6a0d43422ded68"
    sha256 cellar: :any,                 big_sur:        "4e5dd77c036e3e9d1abdd16618c547795083cd0f3a28eb652ccf3a3a7227804d"
    sha256 cellar: :any,                 catalina:       "6347f2636910e87893aa7be12672472f030aba05bdde2445d8ed7d585f98b322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "144cae041e5e211ec773a0c60c9c3d835ac979d1ebc61cd769339bc5d5f8b632"
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
