class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "1dc7314cbda4643186bcf00b6e2402002a113b09a0220e5d564a40e77daa886e"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dd18b88c33a8c26f1f787b329c105427278f13a0657baeb80e28ad3f0ce9dcf5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dd18b88c33a8c26f1f787b329c105427278f13a0657baeb80e28ad3f0ce9dcf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd18b88c33a8c26f1f787b329c105427278f13a0657baeb80e28ad3f0ce9dcf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3884d9f87f91872aa355002375dfae13bf5fb784c329bf8ff8c1e20b933f0215"
    sha256 cellar: :any,                 x86_64_linux:      "f0d4515240ccfc8f75166fd10acf40b90fff5668434d67db8326d7af93752f10"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "generate", "./..."
    ldflags = %W[-X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end
