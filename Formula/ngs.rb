class Ngs < Formula
  desc "Powerful programming language and shell designed specifically for Ops"
  homepage "https://ngs-lang.org/"
  url "https://github.com/ngs-lang/ngs/archive/v0.2.8.tar.gz"
  sha256 "469d0286b506ef06fe30359e1e85e316090ec2f5e5d78eebe7ae1d76d5f660c9"
  license "GPL-3.0"
  head "https://github.com/ngs-lang/ngs.git"

  bottle do
    cellar :any
    sha256 "39660e7b8a4a88b41ab30ec43a832feb487c1813e57f713a3100af05fa8a762e" => :catalina
    sha256 "a4a4fd7ddcfc2d51851a733c117dd3e6076e2ee9b8334fa852c4890a547fe0d4" => :mojave
    sha256 "8a9b038543f6a2fb7f7cd065942c75e76ae971cde8ca448c2aff0bbef9fa59f1" => :high_sierra
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
