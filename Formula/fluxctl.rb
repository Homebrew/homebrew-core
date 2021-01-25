class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/fluxcd/flux"
  url "https://github.com/fluxcd/flux.git",
      tag:      "1.21.1",
      revision: "930a2cc43487033ac70e38f7389a2a573a55fdf5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "53227e9833e63f339d03dc38c1b542debe9bc00cc122e40b128f37be43a7b03f" => :big_sur
    sha256 "21279a68c5e174c9dc901b9de1782716cbc7130d85259ac24234e339a2573945" => :arm64_big_sur
    sha256 "18d0f73be5406c24147a4092f05aed13788032a51c8acb7e3a62709889d2313c" => :catalina
    sha256 "26df944d2b25badcf9cb4a742b442f6e40657be2987b86ad0be7e7cf0296ebf0" => :mojave
  end

  depends_on "go" => :build

  def install
    cd buildpath/"cmd/fluxctl" do
      system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", bin/"fluxctl"
    end
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
