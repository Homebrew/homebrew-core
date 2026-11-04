class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/6.4.1.tar.gz"
  sha256 "c14b402c3a89d5b67a2528abdbf494f14f5bdefdd76e7f198c611f4638666498"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ffc6165919b767462e842715537d2abf853d9fe276793d6833e9f3d0d6c0803"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "235462fc7c5071553563ecc7936f610ea4fe367b0edffffff3cb957d1a03e39c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6f1b6fce971a7c3b0d4c16de89040c6d65d97847934010c36a70446d7d93519d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e46519dfb550ee4a0be307f2566840f642a70a2af24148355e94a164daffbddf"
    sha256 cellar: :any,                 x86_64_linux:      "6b1530976e9a215fba7baed92376b6d38e5487507faf05072a32e8d03e0fbcdf"
  end

  depends_on "go" => :build

  conflicts_with "asccli", because: "both install `asc` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
