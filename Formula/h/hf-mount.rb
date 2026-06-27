class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "38e1e367eddaf1ee0fbba44ed0b449a233704cf00f594076f298907e75ebb281"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ad85157bfa1b4424e005f0cd39416e2dbe32d547559cecea605e61b7fd630f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cbcd85c397739fac5a29de657385e78fafdfc1774260f0b30e870fd6b6d82ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9601b1c119c07674d6f2f8bcbdf11d6e075bbc6bc70510cffd4c4bfa8ac9ced"
    sha256 cellar: :any_skip_relocation, sonoma:        "35aa1fd99c61cdf99b014f504378d206f14a31853887e3268b776ed935cc61eb"
    sha256 cellar: :any,                 arm64_linux:   "84137f02a8dd085f12e69646594cfb6906b5045393f2d21260f5bc5e477b1c4f"
    sha256 cellar: :any,                 x86_64_linux:  "6c91b35b1ddecbdde0156ab5a23a6d206a368d4438d3f7aa14c725ac1d070000"
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
