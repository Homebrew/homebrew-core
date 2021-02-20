class GitIf < Formula
  desc "Glulx interpreter that is optimized for speed"
  homepage "https://ifarchive.org/indexes/if-archiveXprogrammingXglulxXinterpretersXgit.html"
  url "https://ifarchive.org/if-archive/programming/glulx/interpreters/git/git-135.zip"
  version "1.3.5"
  sha256 "4bdfae2e1ab085740efddf99d43ded6a044f1f2df274f753737e5f0e402fc4e9"
  license "MIT"
  head "https://github.com/DavidKinder/Git.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "77774c3b7c788df05c109ad9c40dd256ce0a6d23d39708151acdf39f31e6bb3f"
    sha256 cellar: :any_skip_relocation, big_sur:       "516c050a97d3f364c0fd9358a3e98d7a71e1a99ab948d02ac7dca05ed43a33f8"
    sha256 cellar: :any_skip_relocation, catalina:      "f87fdd2951218631adc744bc2c9f1d83f3230bc49256f45735fc2d611f49dcc8"
    sha256 cellar: :any_skip_relocation, mojave:        "37dc94c423003dedaf313ffa9343879ecb5d72f277a2f250100481cde240420e"
    sha256 cellar: :any_skip_relocation, high_sierra:   "bedbf580c8b073c7dfcd6bbb470aee7c14fb31d2c3ec54b4be8fd2cf8545e577"
    sha256 cellar: :any_skip_relocation, sierra:        "7c09116244a4c04a46337a0453d519523204233fc33d2d60c89c4b9469498380"
    sha256 cellar: :any_skip_relocation, el_capitan:    "c38c41e66ca16a1ef9627112980fa49411b870c2438086db35f6dd9053f99850"
    sha256 cellar: :any_skip_relocation, yosemite:      "e727f112e350e8a12b87094715800e9c2abc03f2d45ad521c0d78e4c6bfff3ad"
  end

  depends_on "glktermw" => :build

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
