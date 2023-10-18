class GoMd2man < Formula
  desc "Converts markdown into roff (man pages)"
  homepage "https://github.com/cpuguy83/go-md2man"
  url "https://github.com/cpuguy83/go-md2man.git",
      tag:      "v2.0.3",
      revision: "f67b5f6400a3ea2156517041a329ae5f5935395c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "048e97e79691bf23cd07ba20b5e9722b2283891e8942d36a63390310250e3fa6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "048e97e79691bf23cd07ba20b5e9722b2283891e8942d36a63390310250e3fa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "048e97e79691bf23cd07ba20b5e9722b2283891e8942d36a63390310250e3fa6"
    sha256 cellar: :any_skip_relocation, sonoma:         "12f89b2211881f08ce4a3dba3e6ad6c41d2229d6ec04c1d9813f0d9460e60053"
    sha256 cellar: :any_skip_relocation, ventura:        "12f89b2211881f08ce4a3dba3e6ad6c41d2229d6ec04c1d9813f0d9460e60053"
    sha256 cellar: :any_skip_relocation, monterey:       "12f89b2211881f08ce4a3dba3e6ad6c41d2229d6ec04c1d9813f0d9460e60053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cdbe2e6e15a8ce883c5c9b28e056acd5f177c6fb38e1e0e134be0ce374f4f3c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    system bin/"go-md2man", "-in=go-md2man.1.md", "-out=go-md2man.1"
    man1.install "go-md2man.1"
  end

  test do
    assert_includes pipe_output(bin/"go-md2man", "# manpage\nand a half\n"),
                    ".TH manpage\n.PP\nand a half\n"
  end
end
