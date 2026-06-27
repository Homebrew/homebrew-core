class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "fbd3e038b35c75adfe70df833d6a805b22f9432275918585c1041ecfcd5c110c"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "754590107a166ce614e75718477f1b2024a0576db91b744cb4308c92b8b683e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71171335b3a297c1fb7e50e2f24b6409369826d607eccdae213e343e6f391f77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d22468b3fb9a586f8d52b5bd8a6d11843dcaaa88e0b5174934dc87cbdbf3102"
    sha256 cellar: :any_skip_relocation, sonoma:        "9db448ab5422f86caa589c9336eb57efb40c3b3719fdfec3ec9580cca43f49a0"
    sha256 cellar: :any,                 arm64_linux:   "e02ceed35fec424123291570a6010064241faf28302973ca8574abd3cfdab3ac"
    sha256 cellar: :any,                 x86_64_linux:  "797cee7005481b0f05b652f00cfbaabb671aca7f68abe91291cf5a4d19428ea3"
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
