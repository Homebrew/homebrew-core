class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "733c18a3fe7af4ff2b8ec259cd1fb3367ff904837fd94fe130b6b30f1d87ce5d"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07e6e8869d5c4597df0a35c0f89e629b295757ca4f067a0f79e9f5e877dd8335"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d22eca68a2716f874d6eab431b1631f67a64dbeaf68ce628f2758bd044e76c17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb7065b940e8e9ffac5543880ee9e558fc87412b533cc3d2a746cd5b2822e1ce"
    sha256 cellar: :any,                 arm64_linux:       "68689cc6276481cdbf002b766fe7a62580b552abc59168ed4641b3cd1b056ccb"
    sha256 cellar: :any,                 x86_64_linux:      "b9f1b0eeca617a70e2603e27fca854377fff99c7cf4c52a36f5f9aaf626ea209"
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
