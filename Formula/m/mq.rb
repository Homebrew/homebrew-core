class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.5.29.tar.gz"
  sha256 "394771f5135d93e8d1f0aaa25fe612a53d662ad31b40b8cae1c6b5954d83d7c6"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9930ec4e4efcaf85ab02fb51ed8b0d011655e224453b4cda04c4c3536c1fa256"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44c2cee475013a2d9651b3f53a96e7fa74db2c5a81399cdae45994e156d3f901"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4db3dcc632cb4758e6615ddd79301b66f066d22b643e51cd103c6247ea74c3e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4a339ad1bcf791a034d0b60aec08689d4a14a8cbabe1a0900479b088b738748"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a6ea6bc6c30a2451c8f6918635569ce8f71171aa563c8b13b7bbb3af3f18181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28efe3f4d1bb370718bd8b2ea72a7e9f77d2bfbddf750fa56016d6a0d7c0680a"
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
