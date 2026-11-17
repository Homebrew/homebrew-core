class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "65ff2e3d4b42d88e01a1189c5074296fb9322a4c1059b9b51ef5919b1df74d45"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8f25110ab40048650b5caacce3510f058ee548f06fe69a2c789e47f26234aaff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "23cd4425b3d73bf2232e8c7c3ba9917a37f073afb65c31e174767b525c29b9e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b5f18b311fe70404debe84963ce0066435a2d37e149b94f0f6ff64c42673937a"
    sha256 cellar: :any,                 arm64_linux:       "27e89b8588295f1906a24291b4807f11c9e30a9059b6f83305c9391f0ebccbfe"
    sha256 cellar: :any,                 x86_64_linux:      "86b6903274360ba1cb079582f8a8fac788ce6ab5470bf85c3fd6c14f32cf7c45"
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
