class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "f760fa96c839400c986d4ff53c25c97f7cf66fcf02725f36fffc097e446ea6c5"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    manifest_sha256 "1a07d68040fddfd8507d3238f1933e5d667d338cdd2371e8b0bcc15b0c4efd5b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c86617e7f379e4669b32c8156b9338def1eebc5c8fbe9cd1cd7231f10a96c7f7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "456a42dd0a12a8d8d37afe5cd0fda575ac8ccf3ff69ea33b037632c57af46c57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4235809daee421f4f37de8fa8a19f47099a3136daca37e80fb0ea4027cbde5e1"
    sha256 cellar: :any,                 arm64_linux:       "c86b34ab3e1f0e559087401684a9e412ed731131d3f9924b333bfc2d3520e771"
    sha256 cellar: :any,                 x86_64_linux:      "58386ba55b4b54b2206a24f0e7206fd0d3017772d4e4a4372f118f9facd44be9"
  end

  depends_on "rust" => :build

  # Sync stale workspace versions in `Cargo.lock`
  patch do
    url "https://github.com/harehare/mq/commit/3aa2a1fa7a726770bc67b14f1123f205747ce711.patch?full_index=1"
    sha256 "c5a005532626d79b792c47b9cccfe4a9a08d7203904c0c1835a5141ebb57eb84"
    type :backport
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
