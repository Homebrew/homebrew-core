class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/fluxcd/flux"
  url "https://github.com/fluxcd/flux.git",
      tag:      "1.24.1",
      revision: "13b3e660ed198b81a9dcd11457664827294074b8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e74157d3b136914d077d897523b588bd2556ef3d4379f66c58c9745b4536215e"
    sha256 cellar: :any_skip_relocation, big_sur:       "4f5eecaae69cb6d7e8dac45f68a8d610d71fdb32f24423bc92b894250a1579a9"
    sha256 cellar: :any_skip_relocation, catalina:      "3d144c86da839cfd4f0895e8579c3e23e49703d8ab770c2e91c8eb55faf352ed"
    sha256 cellar: :any_skip_relocation, mojave:        "7908a409b90874f2bd45d101940f168c8f0e00a68d4e404efc62e9579369dd9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a301b980de2db6a1c8e3e96b7d38afc51e60aef63d4499663fb4c713db47a75"
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
