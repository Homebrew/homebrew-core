class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.5.11.tar.gz"
  sha256 "a61f8436f22d2339047162cec71a740189fdbd1471c1e7b2b5fdf4668ee37798"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e8ea7cf46dbc7a365349fa895261fc4173757ba43b6edeb66d9616fd7949e5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dabf662acc804df31dbf614382b68d4c488899a926b827c15c8a3812f0b561b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c73c78184f8e049e749830598000edbb896946761f3c0b92523efc126d21bbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6add5373ba7d3e22ccaed0adf8764e99d0b6af16cccc7690d2fc04a7e305211"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c0cd7dbfaf0d96c30ce8c3a5b30d17fc904c6ce85b3f5e94f7e8acc2f11ae6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d3c27408ed39b5c3f739f0d8a06769bb4ce6b84080596e2c04c88f699ad31d1"
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
