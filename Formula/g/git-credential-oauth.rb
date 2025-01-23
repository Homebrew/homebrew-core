class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "0b9c23264e67a6cdd423031749ab9c6679c14ce88b1e2c4c5c2219501c70f628"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f35466f105b369eae00115a115dfb2861b411d3a916ac7c8bd0b06ba481d9d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f35466f105b369eae00115a115dfb2861b411d3a916ac7c8bd0b06ba481d9d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f35466f105b369eae00115a115dfb2861b411d3a916ac7c8bd0b06ba481d9d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dbf30c9780ad7d0f97c3045c9ee3a43c50769a2b35fc1f2d8e772b682056ae5"
    sha256 cellar: :any_skip_relocation, ventura:       "8dbf30c9780ad7d0f97c3045c9ee3a43c50769a2b35fc1f2d8e772b682056ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "338032f925aed60be65c0fdf372b543b4a88a2822a72bcd58ff2a23c13468253"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "git-credential-oauth #{version}", shell_output("#{bin}/git-credential-oauth -verbose 2>&1", 2)
  end
end
