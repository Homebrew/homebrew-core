class GoMd2man < Formula
  desc "Converts markdown into roff (man pages)"
  homepage "https://github.com/cpuguy83/go-md2man"
  url "https://github.com/cpuguy83/go-md2man.git",
      tag:      "v2.0.4",
      revision: "d6816bfbea7506064a28119f805fb79f9bc5aeec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "211420e6cb801b56ce5894f1b4e6365d801ff37ec67df5e0306d56134ecf630c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "211420e6cb801b56ce5894f1b4e6365d801ff37ec67df5e0306d56134ecf630c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "211420e6cb801b56ce5894f1b4e6365d801ff37ec67df5e0306d56134ecf630c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3906b15f58c216fefafeee1deb254572c46ceac8ae0ec86818fca73e1570da0"
    sha256 cellar: :any_skip_relocation, ventura:        "a3906b15f58c216fefafeee1deb254572c46ceac8ae0ec86818fca73e1570da0"
    sha256 cellar: :any_skip_relocation, monterey:       "a3906b15f58c216fefafeee1deb254572c46ceac8ae0ec86818fca73e1570da0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c58c021047eaa981dd67810c5fe7d0b03891b69746a498a68397c22c34ba371e"
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
