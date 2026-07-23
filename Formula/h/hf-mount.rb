class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "5b605ae805c05a1238eca341795a0718581c757e31677d8a088bc00707c31acc"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccc2a932da6ffb63d25eefe56ee380c1abc65875a29a1432a8d8760cc52b69f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2de94518fabd79e36762d68cbac4c32346f8a5d56197ddc7fb7ed63a0d45afe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9a72a3b3567914f1fee96df59c5e0a5d9744aa311c8c066a108b8bea1305188"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0e03cdde596afda871e088d7f10a052e43396e3813e65abb3bb3d9dacfb6537"
    sha256 cellar: :any,                 arm64_linux:   "8c1de7989add3f97de25f53ad74a2b8d8eb3da63a63749ffd1dc0d8ea20c6aef"
    sha256 cellar: :any,                 x86_64_linux:  "e9b29d7f1bca4ace429a3df535d9729866747e0332cdc57699e81f1744584a2c"
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
