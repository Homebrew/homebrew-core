class GoMd2man < Formula
  desc "Converts markdown into roff (man pages)"
  homepage "https://github.com/cpuguy83/go-md2man"
  url "https://github.com/cpuguy83/go-md2man.git",
      tag:      "v2.0.0",
      revision: "f79a8a8ca69da163eee19ab442bedad7a35bba5a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c6f05023662243e7c46d5206a1a2af2db7c2bc584086608f18388e1a05ecc755" => :big_sur
    sha256 "c8228c62cba90dfcda781325c0cd8709ee32e31f5ec7eb3471e822e7bb7627b4" => :arm64_big_sur
    sha256 "1ff2123c31e56bc183a1b9b0e270c01ee31e16efc34c060e0d4ecbde87d9e16e" => :catalina
    sha256 "1ff2123c31e56bc183a1b9b0e270c01ee31e16efc34c060e0d4ecbde87d9e16e" => :mojave
    sha256 "1ff2123c31e56bc183a1b9b0e270c01ee31e16efc34c060e0d4ecbde87d9e16e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"go-md2man"
    system bin/"go-md2man", "-in=go-md2man.1.md", "-out=go-md2man.1"
    man1.install "go-md2man.1"
    prefix.install_metafiles
  end

  test do
    assert_includes pipe_output(bin/"go-md2man", "# manpage\nand a half\n"),
                    ".TH manpage\n.PP\nand a half\n"
  end
end
