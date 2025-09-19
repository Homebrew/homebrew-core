class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "844f7deea40c645fcf3a5ad1c7b6648a22306a7a3b4e553fa849475469f60f84"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "480497bd3606d78fa500a0479e7bd799a5b16bd9e0470db760c406696803ec79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "480497bd3606d78fa500a0479e7bd799a5b16bd9e0470db760c406696803ec79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "480497bd3606d78fa500a0479e7bd799a5b16bd9e0470db760c406696803ec79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "480497bd3606d78fa500a0479e7bd799a5b16bd9e0470db760c406696803ec79"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef0f63c024b2b42fc0ee94685b1fbaf6873680d1a46c760e1c03b3f15597719d"
    sha256 cellar: :any_skip_relocation, ventura:       "ef0f63c024b2b42fc0ee94685b1fbaf6873680d1a46c760e1c03b3f15597719d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68bc44274679c3f8574e1aab432b68f3080b45f526e6c094163232a27b0cd63b"
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
