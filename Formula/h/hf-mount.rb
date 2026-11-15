class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.13.6.tar.gz"
  sha256 "925297096e5c742901a7f8ed5f7e1d17f6c53f2f1cd27d8e2213118a13d97108"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8f814aec93ab79c4fc70d09a1b5b71dd6ac4a078832a2add74bc273477175999"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "008c897101d4469a3bd97d6aa6cce37b74e1e3263535f29b33640ac7bf4fc08b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "629d0d9294cfc49d374dee3f3449eee25a13a65e4eebdf718f61575810a1eb8b"
    sha256 cellar: :any,                 arm64_linux:       "1fac802f69e93619154107d10a9c239b60653ff6b774a0f7c6fceb021b841274"
    sha256 cellar: :any,                 x86_64_linux:      "4ae0b11f38793de27094ab8807812186bfe23555cb4181cf8b90be43a3b3be3d"
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
