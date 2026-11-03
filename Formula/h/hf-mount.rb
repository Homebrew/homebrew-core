class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "e0a798fb9d3b8ba302940f8eb84b57a28fb0b6e90ef0580b04fa4ef7dbad79b8"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cda2b2a015284280b103c3d69f2f05938eb8940ef174d5a2f37f625e59a652e9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d38944db5005f4b570a84a48dfb613564da082bf2c2b3cd74d4efca6c5dc9d7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b565ada2c5744bcbc9fe8e5cfa9443e4ada530d94a69fad966bd142fb061bfb"
    sha256 cellar: :any,                 arm64_linux:       "0404b34b9dcde743dae9c02cc7daf2e27ad0a5bab01e6aaf82851392efa046c8"
    sha256 cellar: :any,                 x86_64_linux:      "fc5b521f98e7526b5418425e3c547a30b1b4c6af71a58638aa14481d479dbfb1"
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
