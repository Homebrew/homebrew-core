class GitIf < Formula
  desc "Glulx interpreter that is optimized for speed"
  homepage "http://ifarchive.org/indexes/if-archiveXprogrammingXglulxXinterpretersXgit.html"
  url "http://ifarchive.org/if-archive/programming/glulx/interpreters/git/git-135.zip"
  version "1.3.5"
  sha256 "4bdfae2e1ab085740efddf99d43ded6a044f1f2df274f753737e5f0e402fc4e9"
  head "https://github.com/DavidKinder/Git.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "650bda401bc0a473cc7cfb29ddcf8039d235b2d1d895d15b70e50143d517a4c8" => :sierra
    sha256 "e3c9fe6aba13fad92dac7e5010acdb282902762817d432558a95d3aa1f1c7ec0" => :el_capitan
    sha256 "04c11168167f4998f3bfbd9d3fe603d2c7f583bdf7a5c50630db32bce289b3c7" => :yosemite
  end

  option "with-glkterm", "Build with glkterm (without wide character support)"

  depends_on "cheapglk" => [:build, :optional]
  depends_on "glkterm" => [:build, :optional]
  depends_on "glktermw" => :build if build.without?("cheapglk") && build.without?("glkterm")

  def install
    if build.with?("cheapglk") && build.with?("glkterm")
      odie "Options --with-cheapglk and --with-glkterm are mutually exclusive."
    end

    if build.with? "cheapglk"
      glk = Formula["cheapglk"]
    elsif build.with? "glkterm"
      glk = Formula["glkterm"]
    else
      glk = Formula["glktermw"]
    end

    inreplace "Makefile", "GLK = cheapglk", "GLK = #{glk.name}" if build.without? "cheapglk"
    inreplace "Makefile", "GLKINCLUDEDIR = ../$(GLK)", "GLKINCLUDEDIR = #{glk.include}"
    inreplace "Makefile", "GLKLIBDIR = ../$(GLK)", "GLKLIBDIR = #{glk.lib}"
    inreplace "Makefile", /^OPTIONS = /, "OPTIONS = -DUSE_MMAP -DUSE_INLINE"

    system "make"
    bin.install "git" => "git-if"
  end

  test do
    if build.with? "cheapglk"
      assert shell_output("#{bin}/git-if").start_with? "usage: git gamefile.ulx"
    else
      assert pipe_output("#{bin}/git-if -v").start_with? "GlkTerm, library version"
    end
  end
end
