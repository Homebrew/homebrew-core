class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.5.27.tar.gz"
  sha256 "5888a83dc369f1802a3ae6f7f7037c98a26d177792eefa6bd2a7d37c782d34d2"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1aeaaa4f550a4880c692a0bb3a6c7f729d13ee0e4dd3c93c03aff0fc8500b5f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c511a2c669dabc0ffc9ca6d8032729b06c071ad2fad572b9d39a986a9f14c9bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f67c63488981767ea8f8ee820c8ebf53bb46593799bfeb1f7927d5bbb6df0321"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b76d08890e684958f868f36a4428469e2044c8cc3fb1ece0ecffa94efd53c33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5242c4ebdd354f0989ad64214c75a76eb4155a7dd797628db85cea4ed22f9360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edc2dd0f2d7de5a1f1ecb101c37c488aa1d87fe7e0f528de60228670e9be6835"
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
