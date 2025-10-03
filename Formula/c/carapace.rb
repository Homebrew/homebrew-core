class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "233cfe38869d26baab7ca4bf9a9ed7747d49ceb935ab6ee2565e2b7ba60f5482"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "153414b7160585d7c6956ee774005100ba0ba98ac91ed9f3b3ed44c059401258"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "153414b7160585d7c6956ee774005100ba0ba98ac91ed9f3b3ed44c059401258"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "153414b7160585d7c6956ee774005100ba0ba98ac91ed9f3b3ed44c059401258"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9fcb1b4530c254cd06fc9974fa27e6994a5e4b4b5917f42daeac25ea42beb2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b46d72bbb3b6c7b49262f89f86b371fc724f083c00acb14f05d44ffbfa5c48c"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end
