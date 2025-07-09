class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://github.com/openai/codex/archive/refs/tags/rust-v0.4.0.tar.gz"
  sha256 "e30f904e3a3e9edac865463b4dd7485ee693afb976bf09bc10806bdb132b1d48"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7eb823f98ba2d7f2bfce9bfe87f27138ba8f3f76d582b069ff749ac3f48a42a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d01b98e9dc61f45df72e9f5ab61503ba59bba2651fbbb157b36d74b2ede5d37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31d692ba488dc8623ecc30a1900beabd9dd98af124a015f9d24e8261e814ed44"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1491a9e26f6e58fe1f7ee60b1b3c8a9a0d74fd51e1717059f0aaf61a4cac670"
    sha256 cellar: :any_skip_relocation, ventura:       "69b6152561ef9b0963afc9339675779b9f8af808000bb1dbd123c85b030b0aba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d45c925f0b8c5d8a3ee478e2d34608f5e41776acd0da4903964d596652fc558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "550433a32cdbe80f2c8dac8bed4875532aa101caf652016c49b28dc4ba0339e2"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    if OS.linux?
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
      ENV["OPENSSL_NO_VENDOR"] = "1"
    end

    system "cargo", "install", "--bin", "codex", *std_cargo_args(path: "codex-rs/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codex --version")

    assert_equal "Reading prompt from stdin...\nNo prompt provided via stdin.\n",
pipe_output("#{bin}/codex exec 2>&1", "", 1)

    return unless OS.linux?

    assert_equal "hello\n", shell_output("#{bin}/codex debug landlock echo hello")
  end
end
