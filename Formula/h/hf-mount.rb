class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.13.4.tar.gz"
  sha256 "ebf4f474f8a0082b5ac6c2223e00ba4c5664b81a64f3d8e20bcca0455db98e2d"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c0a06469d4a76c9c9c0b540c56758df976b8d0e61818aebb894447bae3b08727"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7a1ff28c8a767d0e61e1a85dd4612d6a04c79ad440eb6f9707a890e5596bfb73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7f668048bb6ddfa09609b013f175731c3bba48b5cab1d4b92224f13e68dd0629"
    sha256 cellar: :any,                 arm64_linux:       "6fca9bd54c0ad6bc041a96004e58006c2b1676e0e77b4f94df1ee5005aea02a6"
    sha256 cellar: :any,                 x86_64_linux:      "228e6e4498d47dba340b6c6b250949e1526d3cdb38304e507e6c9ab25c9dec69"
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
