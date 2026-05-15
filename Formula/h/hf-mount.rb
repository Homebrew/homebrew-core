class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "4055c4f1939172c11854f2599800c17dbb98737e1ed283e402850641cfb54921"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a03b7c59db16a35483d07920fe64fe765f7e789d377922e74e06db5ad6be27a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a914cff0f0857b5163614b72cfb79d3b6a52fe1232c738ca8f4d15ea0ca0a91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "190ba4740592917c76d88820c92b55bea821afb1db7548a18f99e2806b2c3370"
    sha256 cellar: :any_skip_relocation, sonoma:        "b59c1e0bacfafa8423b50d659139a99ff11dcc8227d90e0399a7aa895c6b399c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27b017e1c33d11d3e57e7934fe7bacbcaa8b677412c04a7816e3c14350ec1ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b542116c67d3855253be862d11c6d4f7fa50480d92cb1e35f643bb63b853507a"
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
