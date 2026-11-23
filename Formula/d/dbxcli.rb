class Dbxcli < Formula
  desc "Command-line tool for Dropbox users and team admins"
  homepage "https://github.com/dropbox/dbxcli"
  url "https://github.com/dropbox/dbxcli/archive/refs/tags/v3.8.3.tar.gz"
  sha256 "ed7a3ab89535bef97ddf64cd8b2a7bef15d7b8c2de911021bf87843a2b33e132"
  license "Apache-2.0"
  head "https://github.com/dropbox/dbxcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9e73ed84d08a46c4e6dcfd6c54eb63eabf6838922bf4dd9ae29321584d70b7ae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e73ed84d08a46c4e6dcfd6c54eb63eabf6838922bf4dd9ae29321584d70b7ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9e73ed84d08a46c4e6dcfd6c54eb63eabf6838922bf4dd9ae29321584d70b7ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "81afeb78b8fac422c7a4c7c81eef3af88b2393a1aba97ebaa3275c4afb943906"
    sha256 cellar: :any,                 x86_64_linux:      "86fb898875e0db102e392408f3cd328953609884ba4fb9d197bab2c59ed6805d"
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
