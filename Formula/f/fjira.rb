class Fjira < Formula
  desc "Fuzzy-find cli jira interface"
  homepage "https://github.com/mk-5/fjira"
  url "https://github.com/mk-5/fjira/archive/refs/tags/1.4.8.tar.gz"
  sha256 "8ae74e699824bf657a183f0e4a4d553f73604c214201e4928b1bb46518c9f3d2"
  license "AGPL-3.0-only"
  head "https://github.com/mk-5/fjira.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdc12e7e6100b6580bb38e988957365bd4360c733f8a6c0a71e50fb2b6765e24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdc12e7e6100b6580bb38e988957365bd4360c733f8a6c0a71e50fb2b6765e24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdc12e7e6100b6580bb38e988957365bd4360c733f8a6c0a71e50fb2b6765e24"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d54a95f16491e412a39a91c9355f85206bff0e73b465dfae6dca01651f55574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a60c5711ea7823d73b8f4eec2858e509909dfa084f2e64816816de08a5bb4a77"
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
