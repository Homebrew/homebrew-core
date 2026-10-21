class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "79d4f2a477e4aa2ebb6a05f05638f8622ccb28d61fbce219f5166f2df67da888"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "35b5f1df8d8a4181431793bddfbaad8a02a86c9d9c4c4363a6c92260eaac7872"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bdaece04ec6329cce369557403b48930f598347ef575ed45ed369eb4032c6d30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "99b1dcf37c319661dc2b0881d75c237710b8b89f0abbfe1af75945a619514dc8"
    sha256 cellar: :any,                 arm64_linux:       "9feac43af05fc47b726baf1a5cd76560d82a9f7bf0ec26a825a75194bc410f3c"
    sha256 cellar: :any,                 x86_64_linux:      "659a45d288b6ae23a5077bee8d05296f43301999f460c8722feb9a639d38c016"
  end

  depends_on "rust" => :build

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
