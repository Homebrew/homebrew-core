class Dbxcli < Formula
  desc "Command-line tool for Dropbox users and team admins"
  homepage "https://github.com/dropbox/dbxcli"
  url "https://github.com/dropbox/dbxcli/archive/refs/tags/v3.8.3.tar.gz"
  sha256 "ed7a3ab89535bef97ddf64cd8b2a7bef15d7b8c2de911021bf87843a2b33e132"
  license "Apache-2.0"
  head "https://github.com/dropbox/dbxcli.git", branch: "master"

  bottle do
    manifest_sha256 "84f62a12898c782f906de4f9cd96b614a4bbb754afae002be202d4aa7562d020"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0a85246e602b1eb12cd6b193b4e52c88a01b24fcd670a4844480eea05fd976e0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0a85246e602b1eb12cd6b193b4e52c88a01b24fcd670a4844480eea05fd976e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a85246e602b1eb12cd6b193b4e52c88a01b24fcd670a4844480eea05fd976e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "89d2ecaad3a928cfea3ab6a427cb11ad2246fe7672336177cd58c99dc5e5dac5"
    sha256 cellar: :any,                 x86_64_linux:      "14551dafdc2f9dfa99d7df19f716645e16678143b327143fdc3dd3cd5d8b3efb"
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
