class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "c74136c6f827655e8517c8881b9b03c1c7ab6b6dcc63f6f0ec530dd946fadc60"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb0ee32dbf4ffad6bfaf5c3e28796f563a3158fadda01c8e59ebe6fcd1ab2ac3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25fb398b145f3f6f36a94f65d53bb1a56fb2a146a4211df6a6f328f0f07545e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbbb0a118725ec6b2d6227fceac922b49ff8134c70c7e9fa0bd3f80168a28697"
    sha256 cellar: :any_skip_relocation, sonoma:        "93fec9da19740e47a4d21f1151a91d218e842bfb87e2f821c8ad206af2d58109"
    sha256 cellar: :any,                 arm64_linux:   "3cbbaba33cd63c7f0eac7b4358d591ee6d818d3a32d3de8d687025fcc0de9950"
    sha256 cellar: :any,                 x86_64_linux:  "76f5d0f24689408e6874638c97bc657fc124ebaa2c53efcffcc50238de20631d"
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
