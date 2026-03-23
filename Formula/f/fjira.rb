class Fjira < Formula
  desc "Fuzzy-find cli jira interface"
  homepage "https://github.com/mk-5/fjira"
  url "https://github.com/mk-5/fjira/archive/refs/tags/1.5.1.tar.gz"
  sha256 "8e7a8879f5d763e22777732151b3439700f2d46c6bc26c24217288eee280ddc0"
  license "AGPL-3.0-only"
  head "https://github.com/mk-5/fjira.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b83a4173e4933fb25d8a195d77373490a078f3a2174bf108f546db78cb41b072"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b83a4173e4933fb25d8a195d77373490a078f3a2174bf108f546db78cb41b072"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b83a4173e4933fb25d8a195d77373490a078f3a2174bf108f546db78cb41b072"
    sha256 cellar: :any_skip_relocation, sonoma:        "c38cd61dcd9d1c5927363e58a6b859a9bd14e79d513176c2419c52c790ede176"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "789050c51754e093aac630a57e92bb81aed1633b1948851f3cbcbbcc85800816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57b273af104278cb40731f2104f484f98a9f86392d83f9b92295b5d93baddc8d"
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
