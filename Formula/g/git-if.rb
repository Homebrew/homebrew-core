class GitIf < Formula
  desc "Glulx interpreter that is optimized for speed"
  homepage "https://ifarchive.org/indexes/if-archiveXprogrammingXglulxXinterpretersXgit.html"
  url "https://ifarchive.org/if-archive/programming/glulx/interpreters/git/git-137.zip"
  version "1.3.7"
  sha256 "b4a9356482e83080e4e9008ea4d0d05412e64564256c6b21709d8e253f217bef"
  license "MIT"
  head "https://github.com/DavidKinder/Git.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1816d6ea69848e3c6c01454ca2c06e305d18fa56167f5daa88737e814bcb5315"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e276ffffb24bbdb9fe565c7c55f79aec5df8d3a4c7b64541bbe73c757e2e45b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb7f09ba2cb7c865b0ee80dd312e28250635a79173c0c2d3781acca03d519ee3"
    sha256 cellar: :any_skip_relocation, ventura:        "405055ae1de47eb0af8b88dbc141b0c9ab8a8b246cc710d2833cdbcc31ff0adf"
    sha256 cellar: :any_skip_relocation, monterey:       "a69998ddf6e70dacfbc12c9c17912fb7ece0e0dad9437201209554a50154f802"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d2791d14db4f96ff76532d537d12d9eda5298e1a7190bd538801cdc3813739f"
    sha256 cellar: :any_skip_relocation, catalina:       "0188ac542b752d94d6b8b544ab5a95ac8608ec0261a40be55ca6fa87140d2e9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f858e0ad782b54d8e630159b9be4dfc3e05a3a5e6f23e1a7378653bf1b54f1ec"
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
