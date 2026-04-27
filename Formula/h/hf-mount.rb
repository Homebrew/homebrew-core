class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "5501a42de124b7c1f13892753b4625e20edb353f7f28b0ce0fc5e461b0688246"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0784e061378f436944a234e7d416366c77e71ead95a6d21750b479f51cd9b08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f033d9cb694d4ee9c676099df9069991d1ac47e21ba36e43394b01300638939e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93680a6e05905e2e41416d210ece1159a82201f9e510aa64a4747096ae1fa248"
    sha256 cellar: :any_skip_relocation, sonoma:        "baf7d0f6b4997b81605085c2816bc759079f5542b3ff93d1fc47f1311eeaea8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bd91051ba45db643e5e086960eb1976167e2fda9757e07e599cec7e8424057f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7153967fd7c1728bbc345e9ae8f3a3ce62e7d79317b1991d75fb1cd89af48f5"
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
