class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "51ca3c3503e96242c8fe68b95baff4b636b47c3e5f67d472b438d67e5f996104"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21c81ef42150adb167a98a896289bed6b03f355d04f5e9454eb5b3b8b734ad28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d464e9f9258ae0620d2956adec02d88fe6757f786a1b48f883ffecfced3cf85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88fc5378247fae12089cd0ef02294604c9d0ffde6a991644bf0641e0c7e120a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f88e248b052b3a8bdb26755d6adc026ffbc6fba009dcd1aaf5082796c41af1d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24ac076871f9ee7195ba92165afa61553d9dd373498ec180692a61d902548aec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ef681099e9f7e05c46bfb7862cf4787306c0fbbbf78a127ddbe7adb531d9270"
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
