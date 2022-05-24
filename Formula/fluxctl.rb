class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/fluxcd/flux"
  url "https://github.com/fluxcd/flux.git",
      tag:      "1.25.1",
      revision: "360a7f7b0f7d0dab52c51a2f4fe3a03921ef05a0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4140d2fb4f97be34da2100dd4bd27f9e2cbe1baa6362b3927b6418bfb5391371"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "869a325e24d25c20ed3ba5ddbcac355e87f5c713e088861e3e54236be3fc60e3"
    sha256 cellar: :any_skip_relocation, monterey:       "52546e57bf5bddebd3e82ac82527f8f3f73e5cde1f3f33387b25408eeabc2218"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f8686dd1f85549a5fc9c0fe99556bb5fe66f9b8456094a3a429c3db9017cbae"
    sha256 cellar: :any_skip_relocation, catalina:       "3aa4fe1fa2d80c65dadff9ef0d6b4344bc9ffd1aa918d3cccdd90c87788ee55a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b4c73c672279b5ca8e13812b48a0ef5d7ab7c0bc0ab92f710264d3b7b521ce1"
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
