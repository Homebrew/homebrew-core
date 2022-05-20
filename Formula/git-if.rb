class GitIf < Formula
  desc "Glulx interpreter that is optimized for speed"
  homepage "https://ifarchive.org/indexes/if-archiveXprogrammingXglulxXinterpretersXgit.html"
  url "https://ifarchive.org/if-archive/programming/glulx/interpreters/git/git-136.zip"
  version "1.3.6"
  sha256 "28d8d7b8d81dac65c19f0b994d54b3c34b182045e86ca399fea65934918d1cf3"
  license "MIT"
  head "https://github.com/DavidKinder/Git.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1cbdac43ba193647b00e4dca570d079cfdf975e520c445e98d9352d51100b91c"
    sha256 cellar: :any_skip_relocation, big_sur:       "56d9c7c7ba0b996340fddcfe108ff45a3e813330f9af771f6b9d398be0b7129e"
    sha256 cellar: :any_skip_relocation, catalina:      "f866a6a21977f9fd16230087f0e5239d8c8b37f7a158fcbb8d257a225e222774"
    sha256 cellar: :any_skip_relocation, mojave:        "f4785e352c5810e9642f490e5c27d02db1ea35c2167cb6c58d88d55002501e7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4f161d016e220b462129394b39b8ea7bad324349a73741489d3c6ea8d65f2db"
  end

  depends_on "glktermw" => :build

  uses_from_macos "ncurses"

  def install
    glk = Formula["glktermw"]

    inreplace "Makefile", "GLK = cheapglk", "GLK = #{glk.name}"
    inreplace "Makefile", "GLKINCLUDEDIR = ../$(GLK)", "GLKINCLUDEDIR = #{glk.include}"
    inreplace "Makefile", "GLKLIBDIR = ../$(GLK)", "GLKLIBDIR = #{glk.lib}"
    inreplace "Makefile", /^OPTIONS = /, "OPTIONS = -DUSE_MMAP -DUSE_INLINE"

    system "make"
    bin.install "git" => "git-if"
  end

  test do
    assert pipe_output("#{bin}/git-if -v").start_with? "GlkTerm, library version"
  end
end
