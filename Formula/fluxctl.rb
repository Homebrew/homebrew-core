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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "92b30058c4f25a2a54cd87cf85da8ebc3c3031f1da6718697985a35d6d38370f"
    sha256 cellar: :any_skip_relocation, big_sur:       "a34f23001a65e4b825f9530c9fdeab01fc460e35514a88edb68827ddd7e8c81a"
    sha256 cellar: :any_skip_relocation, catalina:      "e0d79334b34f6ebc096e859dca4ba9e5d0fe5dbceaf40f25531f6ee0fd160885"
    sha256 cellar: :any_skip_relocation, mojave:        "b7aa54b9bddad2e5a11853ea04a5b301888af88990e414466d00fec8e20a8585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57425da095d46dd789d9f96ad87c0402add627bac2cf28f0a67d0e7abc5dbde0"
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
