class GoMd2man < Formula
  desc "Converts markdown into roff (man pages)"
  homepage "https://github.com/cpuguy83/go-md2man"
  url "https://github.com/cpuguy83/go-md2man/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "ca3a5b57e2c01759f5a00ad2a578d034c5370fae9aa7a6c3af5648b2fc802a92"
  license "MIT"
  head "https://github.com/cpuguy83/go-md2man.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4879fc7e3aa3b31a88c26085ef7f7e15a2cf4df720e6809e26d1a2eb91f31fc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88fbded5a27da6f0f25f33b129b3164a0c4509f49c635c56f5154c3503cef78b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88fbded5a27da6f0f25f33b129b3164a0c4509f49c635c56f5154c3503cef78b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88fbded5a27da6f0f25f33b129b3164a0c4509f49c635c56f5154c3503cef78b"
    sha256 cellar: :any_skip_relocation, sonoma:        "001d4ae9334dbaffa5b3d40beb39a21397ceb816f60a458c765b034bff064870"
    sha256 cellar: :any_skip_relocation, ventura:       "001d4ae9334dbaffa5b3d40beb39a21397ceb816f60a458c765b034bff064870"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa96d601898022e5d295bb25b910340e3a0be8353372480cc6415a38d677f471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a1f544ec626911acd8c1572b41f2de2b97c1c2f49d0c6bcf85f31f12654ab3f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    system bin/"go-md2man", "-in=go-md2man.1.md", "-out=go-md2man.1"
    man1.install "go-md2man.1"
  end

  test do
    assert_includes pipe_output(bin/"go-md2man", "# manpage\nand a half\n"),
                    ".TH manpage\nand a half\n"
  end
end
