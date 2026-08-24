class GitPkgsBrief < Formula
  desc "Tool that detects and reports a project's toolchain, configuration, and more"
  homepage "https://github.com/git-pkgs/brief"
  url "https://github.com/git-pkgs/brief/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "c0f54b886fec1c6bdefe46d6a4f1fb9f82310853fff8ac6042ef5f07eca35183"
  license "MIT"
  head "https://github.com/git-pkgs/brief.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61a08fd58256aed306c774b5f4f02baf2b48252bd8169827c136ffcdde53fe62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61a08fd58256aed306c774b5f4f02baf2b48252bd8169827c136ffcdde53fe62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61a08fd58256aed306c774b5f4f02baf2b48252bd8169827c136ffcdde53fe62"
    sha256 cellar: :any_skip_relocation, sonoma:        "c63b9731857b8bd7e19795cd96b8079e3860a6e938b42427069a4aa9c5c599e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b385ebc3631af7ef88a0bdc983ad00f4fae383e0f50291d4927dd930beaa452"
    sha256 cellar: :any,                 x86_64_linux:  "39cd67fa25dc29e707fd27f48185562889c8caa740146697b475b160506d639b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/git-pkgs/brief.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"brief"), "./cmd/brief"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/brief -version")

    output = shell_output("#{bin}/brief https://github.com/Homebrew/brew")
    assert_match "license_type\": \"BSD-2-Clause\"", output
  end
end
