class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.5.26.tar.gz"
  sha256 "96545080d6289050790988ac99525959c73ea41814044a0b553f8d7769ef2c44"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e2a6b371c83e63daeffe0ceccb4b3a71fc89172070df3ce3cf0d0e6b6339047"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db73666ea5a6abf7b3a11b34f37546776c92a897144cba41b904d4a1e658614e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "425e6de8c7d3d66906d59185dd2147bbb64652d58b95ef8768f275115751089f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4578311e6c426d13bd9279eecffb67d732e64773d7e02b316ebe3c3f385096a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f6c24046e5ebe0b7fff4cf5a348421afbb5335b63f2ea636adcb4df4100021b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fd4a429a2ce2e43e1d14f980ede8177f2f21a2bf68f76642ee598694e62a078"
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
