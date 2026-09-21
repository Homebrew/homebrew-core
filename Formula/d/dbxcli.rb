class Dbxcli < Formula
  desc "Command-line tool for Dropbox users and team admins"
  homepage "https://github.com/dropbox/dbxcli"
  url "https://github.com/dropbox/dbxcli/archive/refs/tags/v3.7.3.tar.gz"
  sha256 "7e8c6817d9b72e0b691a875ea09fdfa04c3243c9ab910a27de15bb3db28499ca"
  license "Apache-2.0"
  head "https://github.com/dropbox/dbxcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a9836a0bb45053f554e032fb77c952a074266e78210e288616c058a4022ac389"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1b2d91c18a5678b651dfd3412534473a9a6161d888a825ea8ce46e1330ccc6bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1b2d91c18a5678b651dfd3412534473a9a6161d888a825ea8ce46e1330ccc6bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1b2d91c18a5678b651dfd3412534473a9a6161d888a825ea8ce46e1330ccc6bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a7c6e224496b931d5422eca603c667c3872bd1583a123e44be46bc02e3bf883d"
    sha256 cellar: :any,                 x86_64_linux:      "3b58ef40ea180781a28d4909cb3e7b7420c548e2fdb148d70d003df8ceece7a0"
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
