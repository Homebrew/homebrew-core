class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.33.6.tar.gz"
  sha256 "d3d2bb77a2f464af34124be3618569476f674ab655e8848318f3e7916c9d19cb"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db4ce725b5955330b4d83fe4cc66628bb986e7fadd9c9602fe91f40c0090ca8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ea7ef1f68ae8933744729f3422593823d0c98d1bda883108d029056df884cda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93c0142dbb5f5927632261b64d98e0173e4dc709219073fe2b52d69c509f217e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4aba5a48a067b23ee634cff8d9a38405168d49b588146fd77ce114454767171"
    sha256 cellar: :any_skip_relocation, ventura:        "86633dc8852949637439834e7bc2788b7818f2bde6f278ea906a9b6143c0ce01"
    sha256 cellar: :any_skip_relocation, monterey:       "fd7b07ebc8255c90d11c4cc098430b8d4de3031e726765ebd2a387c16f75c4e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6eada6c0454ee987bb53388b2d6eab81285a3f2b1afe58be4ee5bd4b41237098"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
