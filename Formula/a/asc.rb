class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.3.0.tar.gz"
  sha256 "0a41ca93f48b96fc909022e370b403c146717a652f0090fc2cf97bfaab2cd275"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1d16cd6bedd6778ccc4e8a02e27fe560a69cf2e6867c165c59e9b438312d059"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c05d95e4ff361e10a327064daa455f63510682fa4585c10b477d2bdf9fc93fa0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "365dd83588438631f40c999c38f368851ea0278fb4cdd3651595389bdfcb978f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf732a8400a0763149a69a577aeeed049e6f625c89cd6b1f235d281cbed85a9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8993a435e4cd538be31dc05c5560e0f4fe9943950c3d9e83bcc187c4bbace3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b7a6d509abb41b2878d19f65fa296ad664f173809606645c4a335135583526a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
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
