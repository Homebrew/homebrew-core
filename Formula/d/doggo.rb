class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "bb66deafb34547c4e2735908ba5c42c6a0c5f30fb2b62dc5f9ff7a11fbe15d3e"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55cd5cb1fd855a26931c937a8c1e4ee14a8522f5ebf66bc01631baa57d03427e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55cd5cb1fd855a26931c937a8c1e4ee14a8522f5ebf66bc01631baa57d03427e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55cd5cb1fd855a26931c937a8c1e4ee14a8522f5ebf66bc01631baa57d03427e"
    sha256 cellar: :any_skip_relocation, sonoma:        "72406c85b8aeaef6359ba85e4c991559c95864989db88a797b4301695ff1536f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb95a59da2fcfe9d6806672b78f1c2fa4470453818a40fd65fc1958016537dd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "268a18dafb27a97dbbf9986ae512c496a2b63e3db3a93b766a9f8d2d56c89a13"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/doggo"

    generate_completions_from_executable(bin/"doggo", "completions")
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "a.iana-servers.net.\nb.iana-servers.net.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end
