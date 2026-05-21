class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "5f642a9230b498942422bcd74bc138d8154584f93ad5a2384c52a10d77d94e96"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cb11f6504bf84238e21680d619f3ac1f5111bf82808ef02b4d920ceebe5f4ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22cfc0e8defe8a4f604d6cb9d5f7aaefe680eaa0af2d3e2d515f4a27d8970ee2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52d275781c87e742c516e52bd0d04a31e2868df4395812be2f7679a051fa53e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b54029667a76ca2f9458908231224a7a45a484c3fd81aa36a2e48a17daed68ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47b85d580817c94af4502b534db0cb6b72f0c0baec75dfba118d0a309697c030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e01e5441194b5cba217ab2f69ef50798a7ef24264d1b4e9e1f74604a296adf3"
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
