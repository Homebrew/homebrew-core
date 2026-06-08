class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "ec9b11d1062a8abd8b4a5906614b7bcfeed82831859cdb05ddb4b61f3991b44e"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb69689f1607c8c733d2769dec7207784a99355e5fedbe9b7672d3ead606cbdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53c8e6cf5e045658ebf2b26c077295c2a44b1dd86b152e2e9127437986b44758"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d7f45954c1327b2e814b17ce185b3a20748d897fd0ba07697dc6c98113dd555"
    sha256 cellar: :any_skip_relocation, sonoma:        "a37d267a987c46d6e948c6b30e45e59ad0e743a1634bb3d626a3f5e09fa6b171"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f085b919a42f29c2ecf4cecc1de71282824194f6305458c355ff2537096de58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db1283bb75cd8d6dc24e14a1d46a75b135ba1b76701cca8dcd217c69086904ad"
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
