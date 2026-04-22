class Fjira < Formula
  desc "Fuzzy-find cli jira interface"
  homepage "https://github.com/mk-5/fjira"
  url "https://github.com/mk-5/fjira/archive/refs/tags/1.5.3.tar.gz"
  sha256 "c69673a92a440c703ce5242fd14aacdb1f1c8f02b69a7cd6b05ee6bbf9fc19d7"
  license "AGPL-3.0-only"
  head "https://github.com/mk-5/fjira.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3576e114d0446d150fb857da28143d2b349c3a1693d0053399e25a9e571d6b22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3576e114d0446d150fb857da28143d2b349c3a1693d0053399e25a9e571d6b22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3576e114d0446d150fb857da28143d2b349c3a1693d0053399e25a9e571d6b22"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4614265019bf889d2c53dfa165e360edba9dff2de5eceb13a3fb99974a242ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8e18c9ca9cba748c58f4de0b98cd4f7b682a4516436fdd64e7f890cf8c1e0b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f3d4257822cce2b03dfbefe4126ec3ee8672a1d2e657d3dc7051a3b2588347f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/fjira-cli"

    generate_completions_from_executable(bin/"fjira", shell_parameter_format: :cobra)
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
