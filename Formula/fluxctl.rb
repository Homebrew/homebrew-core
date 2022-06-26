class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/fluxcd/flux"
  url "https://github.com/fluxcd/flux.git",
      tag:      "1.25.2",
      revision: "710825f0303fa122d9c45bf9b80351d588b8da7c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e92aa7179e6698e857b6f6d81fe0143d50b1263956686861b774aebc194f27a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "492db439155c85b133552246d8a139412ca0a521b256108007144d79c2fa7cdb"
    sha256 cellar: :any_skip_relocation, monterey:       "9d29bf0b4e56f4c970a04fc0a21447af543de7bf1064ea166525602102cb7cd3"
    sha256 cellar: :any_skip_relocation, big_sur:        "757d12cc5b7b57b5604738f79e749497f8e113575ecb559d1584290d980db485"
    sha256 cellar: :any_skip_relocation, catalina:       "cb0167b32c9069329c8ffb3e8c9573b581b7320f0a0b4235d399838b36a9af2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf5eb7f8d684d8f4bd95102bfbcb1330a7e74a5aedb410fc78737d046d43fce7"
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
