class Awk < Formula
  desc "Text processing scripting language"
  homepage "https://www.cs.princeton.edu/~bwk/btl.mirror/"
  url "https://github.com/onetrueawk/awk/archive/refs/tags/20251225.tar.gz"
  sha256 "626d7d19f8e4ceae70f60e2e662291789e0f54ab86945317a3d5693c30f847a2"
  license "SMLNJ"
  head "https://github.com/onetrueawk/awk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f7b544085ef1748054d2608fcf47960b075e7019d0ac02ce1ccffbc253d475a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e98fa35d38461d102fc7d495567653f0e5f480cb76371d5d3a1ba5d51e5dc0c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6212f1398e2060973ae7162c8065ffcc43626faf85f2546b1e843ac6df8c603a"
    sha256 cellar: :any_skip_relocation, sonoma:        "26ad610e1d59ff73a5ef82043fd65532ffd823887d557b0ae0d6aee4118e9546"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68a2fadd6010beaf7e19ce1043d24e726ef67662a9ed8e4a5a626a45ba849e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f21ff67369791acd4905ac3b9bde948e67060901b6c25df4404fc03ef4406d8c"
  end

  uses_from_macos "bison" => :build

  on_linux do
    conflicts_with "gawk", because: "both install an `awk` executable"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "a.out" => "awk"
    man1.install "awk.1"
  end

  test do
    assert_match "test", pipe_output("#{bin}/awk '{print $1}'", "test", 0)
  end
end
