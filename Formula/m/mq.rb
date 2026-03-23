class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.5.22.tar.gz"
  sha256 "e30bac7aa44c97ca8e148ef1b9451b4d33516c7c9f6dc22ca4fe39d052b8e531"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b11babf90b21a0931854554ca8eae8ef119837881c153dfc87ed6b9f04c77dd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8023a8caa48f1377b17616c692e9429f2587c9e9eb3ec0d9a662cbfb01205747"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ab857c61cadc16292cf7c7bafe4a86defc3aa58e2495bb8f213d64f4f97bd59"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ec33b8c482b18e003d46338eb6edd0f76a82eca0781ecd13a619aa27c4e79b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57460e8c86582e2fe0f4cd34f680a0c0994279f106ae9e9a4a7fd185086ff27d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84758c476855a907728b107d2a7777effeb455d76ecc0a2d25e1689956aef2bf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mq-run")
    system "cargo", "install", *std_cargo_args(path: "crates/mq-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mq --version")

    (testpath/"test.md").write("# Hello World\n\nThis is a test.")
    output = shell_output("#{bin}/mq '.h' #{testpath}/test.md")
    assert_equal "# Hello World\n", output
  end
end
