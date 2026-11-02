class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "e0a798fb9d3b8ba302940f8eb84b57a28fb0b6e90ef0580b04fa4ef7dbad79b8"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d78a019b40925f06b9d64e5ddd07c1ab02f0d2f18aeaa892e81b05d3a9779040"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d742740da60b5471546c56c26ec2001a8045c2fb330e48e7bdb48df1e9a47203"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ffedf36b432549628f77c0e4e8b2f95c6841a41f38a2f21b0f1481c8c275f568"
    sha256 cellar: :any,                 arm64_linux:       "532cc29db0dd615ac1de0183c71691a1a216fd5f0ee8a7c0e342a8e01fbd61b8"
    sha256 cellar: :any,                 x86_64_linux:      "1ba50eafa81ff30ea6f77e0e6655f5a52f9c9774afbd4d2d0b565e896556ee2b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libfuse"
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # macOS FUSE needs closed-source macFUSE (not allowed in homebrew/core)
    features = ["nfs"]
    bins = ["hf-mount", "hf-mount-nfs"]
    if OS.linux?
      features << "fuse"
      bins << "hf-mount-fuse"
    end

    bins.each do |bin_name|
      system "cargo", "install", "--no-default-features",
             "--bin", bin_name, *std_cargo_args(features:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hf-mount --version")

    # Daemon registry commands work offline and exercise the PID-file machinery.
    assert_match "No running daemons", shell_output("#{bin}/hf-mount status 2>&1")
    assert_match "no daemon found",
                 shell_output("#{bin}/hf-mount stop #{testpath}/nothing 2>&1", 1)
  end
end
