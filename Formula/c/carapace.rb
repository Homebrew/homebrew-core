class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "b20afecb54a7ddaa12bc931ae081bf0e017c163ceb7d14bfcd571a286741ccd2"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    manifest_sha256 "e421314fcbccca1452dcfc872c26939388ec91020e5b58cc15ebf77c019bd2c3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "110162ab888a66f8a53fb742b41d7fa4c6416a8282f4e2222192e7b50df537eb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "110162ab888a66f8a53fb742b41d7fa4c6416a8282f4e2222192e7b50df537eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "110162ab888a66f8a53fb742b41d7fa4c6416a8282f4e2222192e7b50df537eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cb5a803952309782dddb8e978aa6e15e3df2d592ba6b18879f006cefc8491a58"
    sha256 cellar: :any,                 x86_64_linux:      "7216a69a3d6d1400ea3df23f1639076be9388b1efec75fd82e9f8e03f0cecdc9"
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
