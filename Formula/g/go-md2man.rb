class GoMd2man < Formula
  desc "Converts markdown into roff (man pages)"
  homepage "https://github.com/cpuguy83/go-md2man"
  url "https://github.com/cpuguy83/go-md2man.git",
      tag:      "v2.0.6",
      revision: "441631534462b74c098953dbd8d5f6210994b0bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "386385f734e6980cd796ef8c730ce0a24cda6258d62583f63adbb4770b5a246c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "386385f734e6980cd796ef8c730ce0a24cda6258d62583f63adbb4770b5a246c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "386385f734e6980cd796ef8c730ce0a24cda6258d62583f63adbb4770b5a246c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f403e810b84edebc51c4f8e23f6a9f944e7259df273976f8bce39c0f2bf704f"
    sha256 cellar: :any_skip_relocation, ventura:       "3f403e810b84edebc51c4f8e23f6a9f944e7259df273976f8bce39c0f2bf704f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b560a2b606a1bb4065ec10a33dad917042b3cbd182e5bd900434d9555135b5cf"
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
