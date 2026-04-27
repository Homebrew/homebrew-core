class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://docs.projectdiscovery.io/tools/naabu/overview"
  url "https://github.com/projectdiscovery/naabu/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "8e0981963870f0d647f6ea1e672cc0f7173faa86f230f3c4485e0b56c9c8a010"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e70b6d1f3f5d0d6225ab101576d10e427c37b825c9ffdfcd6307fa12bbd840c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2aa8669014a59969cd446c51cb60e0cf37b3690f71181381e2dffac26b6573c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8eed25f635d96383d4b91822267924828cd3cc66c6ebc8d4b1865b69c74121d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7791466093f5516917ad20932bb14acfed68a46eb8dcdc3b1dae34f72df5ea3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a994f1a8926fe3fb914148f030014ba33fe77aaa2d2b407bbdbc20508e66acb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c4b19c1d33cbb3acafaf714f9e0772e1f510e91b1e5deadd70b6b033ca50fb7"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  # Update version. pr ref https://github.com/projectdiscovery/naabu/pull/1679
  patch do
    url "https://github.com/projectdiscovery/naabu/commit/5b69cbf18a458f0e9df7b2ad4f99cd66bfac7eb7.patch?full_index=1"
    sha256 "b1560422063ea803dce107c7bf21b7ef1eecb90e7a770ecda85b70e79399cc86"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/naabu"
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")

    assert_match version.to_s, shell_output("#{bin}/naabu --version 2>&1")
  end
end
