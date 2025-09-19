class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://github.com/openai/codex/archive/refs/tags/rust-v0.39.0.tar.gz"
  sha256 "6a5584bbbcb30751432bba689b4454103549ab61cc7eb67a34c5d91e2a319e1b"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48ff88cf328f52b19a9737b34e556230e7c9bca7594fe33589439de39f27aafe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43c8b239b5ffeebf2e333bacf31103a3dcd1188ea1111448169f90ec19eb837b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "457c1ae3d74b443cff704b9c338a806799ac6732146eba27af51c65347caff35"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4c7621d328922fcf883fdc9bf4298c0d6d1eba1793937537b0aab9b5c1e4ead"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8bc0fce9778d8dd6167038018f645625df6c2542a65400732a9f8a698bfe459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "261ef504f0fa3e37fad2be4cc96a36bc13c65c6cbda718d15ab15b7eded0614b"
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    if OS.linux?
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
      ENV["OPENSSL_NO_VENDOR"] = "1"
    end

    system "cargo", "install", "--bin", "codex", *std_cargo_args(path: "codex-rs/cli")
    generate_completions_from_executable(bin/"codex", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codex --version")

    assert_equal "Reading prompt from stdin...\nNo prompt provided via stdin.\n",
pipe_output("#{bin}/codex exec 2>&1", "", 1)

    return unless OS.linux?

    assert_equal "hello\n", shell_output("#{bin}/codex debug landlock echo hello")
  end
end
