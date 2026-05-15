class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://docs.projectdiscovery.io/tools/naabu/overview"
  url "https://github.com/projectdiscovery/naabu/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "2bf03345fd3d640624a07c6e255470a342d1e6a7c071d748c57eeb0d40955a8c"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbf766fce35ac41662dc411ee2496a9a42721b976aa77b22cd445a76a634802a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91fbf8c55a0baddeab213d308a593a020b534aa58164671a6a0894ce7cba4051"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37a395e052309d1df92dbee21f836469efff85e4f98f1bde3e391d082e6f7d36"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a5ea0285fe0d48a52039f76d01270152ce2a5b7cf2d0d6ab1ce91c3759a5f27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f102f91947ac3574de90d599c390e9646bd25d8b078f4aaa10fff02d7c28844f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd7889b5172442a61c75c07d8e21f53cb63132ef70424fd5280cfae2671213ef"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/naabu"
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")

    assert_match version.to_s, shell_output("#{bin}/naabu --version 2>&1")
  end
end
