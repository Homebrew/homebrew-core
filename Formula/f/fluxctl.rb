class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/fluxcd/flux"
  url "https://github.com/fluxcd/flux.git",
      tag:      "1.25.4",
      revision: "95493343346f2000299996bab0fc49caf31201dd"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "532a97ba265b178ac52c7cfc91128c6640e70902a3caa48f424aeacd0649dffc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49440ef8e08d4acb3ac71b28e2841b550b2424b5d6e3dc1210d4af30c023da11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9eba83c3ffb83bdae327868f9a20bac78ae0aa525d3bb6013d19386a6b8567a9"
    sha256 cellar: :any_skip_relocation, ventura:        "84ec4d8c604127df3701a3c27a025ae43317c6dde15f6ace39c3966ef66f56da"
    sha256 cellar: :any_skip_relocation, monterey:       "9220f29d722241a3ef7ee0b045f157044f873bdbac3a4e27639855634c9a47e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a95cb0085f72719f5091a06617a2f33d66ef9711b29634e72772560988063de"
    sha256 cellar: :any_skip_relocation, catalina:       "fce44e9caff89a9bd2b110ed3d7ee5aad3281b6e15d17fd472c41c4831b5868f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb1422ea17a36f149248bf4952d19d72a7d56907efe589072dbeef12eeaa77ec"
  end

  deprecate! date: "2022-11-08", because: :repo_archived

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/fluxctl"

    generate_completions_from_executable(bin/"fluxctl", "completion")
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
