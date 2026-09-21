class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "5b567736a1fd715786d0a98190679c7055176538f39947cd77c99f83d6939f06"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7f79dfd78bc065f66a9a39db39fdcd1605e9d3c2c6a269707074248632809b09"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ace84ce0d4566e7083fea5a5e4f1a9b23a73e1d93f191ca554fd73f8b667102e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "852bebed1e3027891c0993742947cd6f5c7504f238d93f868accaeb5bf7fce26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "5768d7495ac2f310671164276b5ee2cbf840c2cdd47169b18748f750d0c2dafd"
    sha256 cellar: :any,                 arm64_linux:       "73b7e6581502a5e7a587b17c37274a9f4074dfe18151d860b0462838d6bb6d99"
    sha256 cellar: :any,                 x86_64_linux:      "deaa6a1cad94a42ae7b0ec69b9bde0df5bf582635c6e7e8d73374a0ea92c387b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libfuse"
    depends_on "openssl@4"
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
