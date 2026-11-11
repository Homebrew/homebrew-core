class Dbxcli < Formula
  desc "Command-line tool for Dropbox users and team admins"
  homepage "https://github.com/dropbox/dbxcli"
  url "https://github.com/dropbox/dbxcli/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "d87aae78cf765c769d07458ac509ebfed55c5eccf83a38204f4648649cf64aa0"
  license "Apache-2.0"
  head "https://github.com/dropbox/dbxcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3395966895e25f8051fa3db5ba40a5d3fa36884c348d3d60cdf73a047f19aa10"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3395966895e25f8051fa3db5ba40a5d3fa36884c348d3d60cdf73a047f19aa10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3395966895e25f8051fa3db5ba40a5d3fa36884c348d3d60cdf73a047f19aa10"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ece0f3d4f3a10edb54cb431ea8c59710706511b7087bcdcc82b680ef9fc8abc0"
    sha256 cellar: :any,                 x86_64_linux:      "5b0aac11956a9dd84c10a2e1bc9b66b12618f2f1234cda1d279de1081c54d21b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"dbxcli", "completion")
  end

  test do
    ENV["DBXCLI_AUTH_FILE"] = testpath/"missing-auth.json"
    output = shell_output("#{bin}/dbxcli ls 2>&1", 2)
    assert_match "no saved Dropbox credentials", output
  end
end
