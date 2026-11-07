class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "dec41709b9cf8db0995ff8157501264f0545597da80a7dae214970669c7e1f18"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0815958f2dec76d1023aa191da174899e3ee51aeed5bda425dc4917608de9d4c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e4a4e866ee3b8aaeffa56e681cf9e54004657c1bfd810d14145c4dbe1924aeec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "65bfb302093ef2d5710690c65b7acffec9125bb70876f1284935680e98851606"
    sha256 cellar: :any,                 arm64_linux:       "7747937b7472e6b48f04335a21174a78b8a61b383a3497d9fafdef25da739ab4"
    sha256 cellar: :any,                 x86_64_linux:      "d444db5a6c3f8d921d81334848fa648f3092c30f96b3dae4586b3921e68ad043"
  end

  depends_on "rust" => :build

  # Sync stale workspace versions in `Cargo.lock`
  patch do
    url "https://github.com/harehare/mq/commit/598e258355adc47ff0550d9a29bc23ef47b44633.patch?full_index=1"
    sha256 "62cce5ecdd76438abcca477a16eda4222d2befc77d434f101cd131571b143f84"
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
