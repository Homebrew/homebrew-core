class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/fluxcd/flux"
  url "https://github.com/fluxcd/flux.git",
      tag:      "1.24.2",
      revision: "603cb67333d628b8e297432f5998bc46356cf46e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4367099ca4ebba8542d686d6415c886e8869d39de7d24e191b8c7bf305355a8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5749efbc7c188da67c9bb7f04495fdfb733f549a62539089317bd67b68cd3790"
    sha256 cellar: :any_skip_relocation, monterey:       "a939665a2dea5b14bb7894146fb9c1528a1fd1013d5fc397441d967f3ab9d425"
    sha256 cellar: :any_skip_relocation, big_sur:        "3279afcbddbbc684c94215618215a848908bff67f76fe6d2aa1ec1b9d90228af"
    sha256 cellar: :any_skip_relocation, catalina:       "fa429bf0f82793675f7b18b1a7d3f1d9363aa57b5374dca62edd6d8d035beb5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "647746b9ed6d6b2d2e2a25aeef92d95d0bfcd0c21ee07e8f8f22d4277c137734"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/fluxctl"
  end

  test do
    run_output = shell_output("#{bin}/fluxctl 2>&1")
    assert_match "fluxctl helps you deploy your code.", run_output

    version_output = shell_output("#{bin}/fluxctl version 2>&1")
    assert_match version.to_s, version_output

    # As we can't bring up a Kubernetes cluster in this test, we simply
    # run "fluxctl sync" and check that it 1) errors out, and 2) complains
    # about a missing .kube/config file.
    require "pty"
    require "timeout"
    r, _w, pid = PTY.spawn("#{bin}/fluxctl sync", err: :out)
    begin
      Timeout.timeout(5) do
        assert_match "Error: Could not load kubernetes configuration file", r.gets.chomp
        Process.wait pid
        assert_equal 1, $CHILD_STATUS.exitstatus
      end
    rescue Timeout::Error
      puts "process not finished in time, killing it"
      Process.kill("TERM", pid)
    end
  end
end
