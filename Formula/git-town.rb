class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v7.9.0.tar.gz"
  sha256 "316002e79bb60bb0ef694720c3c220aa543d21abcd9bacb604d7209d66629ffd"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1937f0e303d533a41012d85d0a6cdcd1833f0e5e5471decc82e28b6c7eb36cf0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c540972c1a72fa5bec7e88f9e5085c336e7a91cfa92869695d4f5966384c284"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "482927f18ceb783fd734c3587f2e0e2d2dd8f064febfaa0480484f96d7cf9422"
    sha256 cellar: :any_skip_relocation, ventura:        "448bad8826e215a4f1b63bbc48eaf30c4b18ef826cba3724bf8ab3904302b022"
    sha256 cellar: :any_skip_relocation, monterey:       "c07d852013444b7c86cb444176a1e4cd9ca6cffd330b15a039bb1e755866b79a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b168506224a0796e64822867b34671427f1812be227800fe961a67e98f951a43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f0481cbaadce15a8c33609fa2150c0bbbd2afcc52eb8da87265fda040dee01a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v7/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v7/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town version")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end
