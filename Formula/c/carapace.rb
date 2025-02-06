class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "7eebc2b3f7ac4fb5641612343ce813b2f7e1c0fffd1251255542e9bfbf9ed207"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab958d8b6688faad9846fa5d54cb997b324a0b0f1b502898de7818734366e979"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd198a0db96a9a30129581ae87c2bec093ca729f11c7f2177d33a726045a5248"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1797a9a2fed88988c4e9d11a60e1724017c41f2ae820136e27b6648ba42efdb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3633532d8779aa3de86077de825f0d2b6f476164cb95adc2df431075669aa805"
    sha256 cellar: :any_skip_relocation, ventura:       "708ee323c68cb1868de4a194420a4e10fe069e0ba477fed712338af8af6d9b4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d2ef2cd0a5465b655c7f2cf7df2289b76573e61e674506e5a8535504c32974e"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "-tags", "release", "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "_carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end
