class Fjira < Formula
  desc "Fuzzy-find cli jira interface"
  homepage "https://github.com/mk-5/fjira"
  url "https://github.com/mk-5/fjira/archive/refs/tags/1.4.9.tar.gz"
  sha256 "b0754c8e3e5126918f063d285cc6fa9fd34c4e1136c1377fc4de9a4e2bbfd6a5"
  license "AGPL-3.0-only"
  head "https://github.com/mk-5/fjira.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5242e1acfbf6e1549c28d1159270b65ab33fedb5aebc19ab8dec448378bb505b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5242e1acfbf6e1549c28d1159270b65ab33fedb5aebc19ab8dec448378bb505b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5242e1acfbf6e1549c28d1159270b65ab33fedb5aebc19ab8dec448378bb505b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d16abff2ed1dfba9df90a348b1eba3613c3cd61fe3f661782af358b8ae73a222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51f87ef9441e760c1ebb2c8f60a136be0b3238355d8ba8e4d8a984ab3b101576"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/fjira-cli"

    generate_completions_from_executable(bin/"fjira", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fjira version")

    output_log = testpath/"output.log"
    pid = spawn bin/"fjira", testpath, [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Create new workspace default", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
