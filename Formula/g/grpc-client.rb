class GrpcClient < Formula
  desc "gRPC client with integrated React UI (Go backend + embedded UI)"
  homepage "https://bhagwati-web.github.io/grpc-client"
  url "https://github.com/bhagwati-web/grpc-client/archive/refs/tags/0.0.1.tar.gz"
  sha256 "dd6d79b60862db320e182475309c9dd27e63a11011603ca3876b0309e9b6ae11"
  license "MIT"
  head "https://github.com/bhagwati-web/grpc-client.git", branch: "master"

  depends_on "go" => :build
  depends_on "node" => :build  # required to build React UI

  def install
    # First build the React UI and integrate it into go-grpc-client
    system "bash", "build-ui.sh"

    # Then build the Go backend (which now includes the UI files)
    cd "go-grpc-client" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end

    # The Go build should output `grpc-client` into bin (via std_go_args)
    # No extra files or servers should be started here.
  end

  test do
    # A minimal smoke test: check that --help works (without actually launching the server)
    output = shell_output("#{bin}/grpc-client --help 2>&1")
    assert_match "Usage", output
  end
end
