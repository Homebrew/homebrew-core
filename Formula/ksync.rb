class Ksync < Formula
  desc "Sync files between your local system and a kubernetes cluster"
  homepage "https://ksync.github.io/ksync/"
  url "https://github.com/ksync/ksync.git",
    :tag      => "0.4.5",
    :revision => "9f40bf134329814a57e1a58d73b84761a2b06c73"
  sha256 "bd47c5b5418bfc6d2f08abe855a52d4189f8bf380747cdd4e5c1a3ca0a87498a"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    time = Utils.safe_popen_read("date", "+%Y%m%dT%H%M%S").chomp
    goversion = "go#{Formula["go"].version}"
    commit = Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").chomp
    system "go", "build", "-ldflags",
              "-w -X github.com/ksync/ksync/pkg/ksync.GitCommit=#{commit} \
              -X github.com/ksync/ksync/pkg/ksync.GitTag=#{version} \
              -X github.com/ksync/ksync/pkg/ksync.BuildDate=#{time} \
              -X github.com/ksync/ksync/pkg/ksync.VersionString=Homebrew \
              -X github.com/ksync/ksync/pkg/ksync.GoVersion=#{goversion}",
              *std_go_args,
              "github.com/ksync/ksync/cmd/ksync"
  end

  test do
    # Basic build test. Potential for more sophisticated tests in the future
    # Initialize the local client and see if it completes successfully
    expected = "level=fatal"
    assert_match expected.to_s, shell_output("#{bin}/ksync init --local --log-level debug", 1)
  end
end
