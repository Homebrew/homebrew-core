class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "aa4f217bfab2838e1224129cdfa578de80c911f7b78ea94b48cd6b263aa241af"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d57259dedf4d5817fe9e12812ea98fb4e4564169c43a88d2db4c3f9aa563cc21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fed3d8a4fe08cc54de52340a3d4173811cd10828e2e3f45166ac8ecff8ec0dc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "836a7d53ab1dd651186466d0a9deea772e85216e5938a4771119d2e8257e02c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b48c19fd7fea23b49265099bda875535846acb6fdddb0b72fb95d0b42c7c5b6e"
    sha256 cellar: :any,                 arm64_linux:   "768b9dfb3d84af6f98822ce7ccddf711e9188ca9bd8ada08bdb446ba7054b531"
    sha256 cellar: :any,                 x86_64_linux:  "18d670863f50ca65f4562020c4867e4fef5451b6fafccb5b95dab01efe6a5d8b"
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
