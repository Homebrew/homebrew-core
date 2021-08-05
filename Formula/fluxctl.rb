class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/fluxcd/flux"
  url "https://github.com/fluxcd/flux.git",
      tag:      "1.23.2",
      revision: "c2d39c3f6e0d77865a817b045e632b91d3fadcd4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ef649d6e8b7906ab4cc7fe3fa443845f7372ad4f047b2a757748bdeb963f2581"
    sha256 cellar: :any_skip_relocation, big_sur:       "ed7a10a3de2a283d07d53c5fa8b5b1037bc839d49375db719aa113a8169a4afb"
    sha256 cellar: :any_skip_relocation, catalina:      "e03fad6e912e70db5684f83f3c83e38297484930d292e21b1f655ffe8742a990"
    sha256 cellar: :any_skip_relocation, mojave:        "0f86e7620bea2bf83d2359b2f75e83e82b9ae15d89a6df818e885bc6276d7ec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf8938a3770a159ec824d8f261530e3cc44f8829f55c50683ba44c6de4c992e5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}", "./cmd/fluxctl"
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
