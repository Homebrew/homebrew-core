class Dbxcli < Formula
  desc "Command-line tool for Dropbox users and team admins"
  homepage "https://github.com/dropbox/dbxcli"
  url "https://github.com/dropbox/dbxcli/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "d87aae78cf765c769d07458ac509ebfed55c5eccf83a38204f4648649cf64aa0"
  license "Apache-2.0"
  head "https://github.com/dropbox/dbxcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5b88270d5757863e666386aa9bea39d2873a5958a841774d1e79049d44f0a1ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b88270d5757863e666386aa9bea39d2873a5958a841774d1e79049d44f0a1ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b88270d5757863e666386aa9bea39d2873a5958a841774d1e79049d44f0a1ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f0f6f035535a22d5397fe575cc57aabc8d877926c53c1a3b7299e2c2728d0b8d"
    sha256 cellar: :any,                 x86_64_linux:      "f60a7f1abffff9d4d450b1df15c95579e32271ac718e4b6c0b97bc3abe4b07bb"
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
