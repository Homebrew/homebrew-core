class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "b20afecb54a7ddaa12bc931ae081bf0e017c163ceb7d14bfcd571a286741ccd2"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    manifest_sha256 "d3c78c3a86f295398930829450ec93ffd273c3ecd516ea5c1e4bc4c885eba47f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d2687cfa2ea4287de3ad6c3caa647b41480882ba9321332550d9c98461c14dc4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d2687cfa2ea4287de3ad6c3caa647b41480882ba9321332550d9c98461c14dc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d2687cfa2ea4287de3ad6c3caa647b41480882ba9321332550d9c98461c14dc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "12f5dac7bc320ed096310d41bf0774856864ea557ce73267e4d68e53b2acd5a7"
    sha256 cellar: :any,                 x86_64_linux:      "75dcde255f44e6996301eedb6e09cadb18720df78788218eb8944456f202e387"
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
