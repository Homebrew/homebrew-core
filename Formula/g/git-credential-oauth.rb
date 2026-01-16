class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "23769afc87f82fe21b5519d059bb5ce56b2fad2c4abc7ecde9bff49a4e065ab6"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d60c85756632b4de61dd73bb072f703614786ddc20d26a67ca4923a460753b36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d60c85756632b4de61dd73bb072f703614786ddc20d26a67ca4923a460753b36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d60c85756632b4de61dd73bb072f703614786ddc20d26a67ca4923a460753b36"
    sha256 cellar: :any_skip_relocation, sonoma:        "a060d242f2a2be956538ce2600049cedf2199a134e6e16af90f3c28b8f322630"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7920c04e1ffa86ec1d3c287fbed4c1f8ba1623b003124fadab736b8c4aa0acef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42bd76ff4cfedf495012509915065ac573a0a19da4ae3046949eb7c1621589a1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "git-credential-oauth #{version}", shell_output("#{bin}/git-credential-oauth -verbose 2>&1", 2)
  end
end
