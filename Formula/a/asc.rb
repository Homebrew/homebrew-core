class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/6.6.1.tar.gz"
  sha256 "e0da111ab115bdd1fcccb97ca3cf2b7abf827797923423de997398df0f49cc02"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "794e33b9891ef129386b722f5d81510cc28709ad2a84cc7370ff294a7b55efd9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e122cae37d077a328579535c3c4b40e85870344ac0126b5364098ea454985349"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fb80fe8f73e2b1ba1fac0c50621ffa62b268995cec73b6e730a32c2758fd3a5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a923d5518b218021bae6eb0f64a2c2193630ff73df97bc83025d08e8370bf550"
    sha256 cellar: :any,                 x86_64_linux:      "ca7dce63ba7ce224775d79073ff60bb921860107fe2e4d081ee0abd3814270b9"
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
