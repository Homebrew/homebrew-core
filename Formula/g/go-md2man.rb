class GoMd2man < Formula
  desc "Converts markdown into roff (man pages)"
  homepage "https://github.com/cpuguy83/go-md2man"
  url "https://github.com/cpuguy83/go-md2man.git",
      tag:      "v2.0.5",
      revision: "b14773d4db11046c50d0d1c05955839604aae991"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1688591f368bcff0f7570bc26db52b35ce57e8080ff34c47210e9aa4f881fd30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1688591f368bcff0f7570bc26db52b35ce57e8080ff34c47210e9aa4f881fd30"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1688591f368bcff0f7570bc26db52b35ce57e8080ff34c47210e9aa4f881fd30"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5931e14240a993944ec49813e0059e638af688e66e4091ea0467cace7a85bd8"
    sha256 cellar: :any_skip_relocation, ventura:       "b5931e14240a993944ec49813e0059e638af688e66e4091ea0467cace7a85bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d33463c6582ce1cea93e4c7876d922c8b36d67d6a7029cdc1828d58e12798f7"
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
