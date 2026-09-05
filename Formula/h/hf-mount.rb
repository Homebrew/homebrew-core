class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "10dcb56e216779a33a99d25a716673cb0aacd16ea675410292560032e5b42e61"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89b2492c85dc7dfc4013dbc614b6498ad542141d0cb6d057cd70cfbfa913f1c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cf95cd5d186d5b7dc8fc8076911581ea3ea02e5054960e788063450e1fbb0a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "736be132ff0f893a1b6dcd9848c9a6508511f89be9a900795c9aa58fc9bf07c7"
    sha256 cellar: :any,                 arm64_linux:   "d07d4336b1768cf9489d4ad29d07e73b0d463a9f54087386bc5ce8f3120ab80c"
    sha256 cellar: :any,                 x86_64_linux:  "da18ab85473823d8cfb6d2ec89ce5e88342420180116cf99646605bae15a673c"
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
