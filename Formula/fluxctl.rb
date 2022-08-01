class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/fluxcd/flux"
  url "https://github.com/fluxcd/flux.git",
      tag:      "1.25.3",
      revision: "0fa27a98c4c370607c7a4e647bdf439dfc5345f1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73d76d61bc6c77f8610aea5986ef1596b661485fedd6862ee92a2d2eb79b622f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "129b09129e9f0134907c4759011da59ea246a9e7e1ffeb807463c60c7e21ecaf"
    sha256 cellar: :any_skip_relocation, monterey:       "d5ac01cc0e8965656aa7ad88363252b07033503a85ac8e7698455b1bbb9c33b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cd6821331c6ce4a3318aebfe29069d65b3c8c050d896754e4c4ecc0ecde5336"
    sha256 cellar: :any_skip_relocation, catalina:       "a2c486a31e37558a27dc9400ed7fd73cdb3d6ea7027046212ed73ebccaea7907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c27b5b937414a8c5cfa59b6d6287ce519b8884bff162a8ef0254f2d2f78d7a4c"
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
