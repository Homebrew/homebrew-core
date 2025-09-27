class GrpcClient < Formula
  desc "Minimal gRPC client with integrated React UI (Go backend + embedded UI)"
  homepage "https://bhagwati-web.github.io/grpc-client"
  url "https://github.com/bhagwati-web/grpc-client/archive/refs/tags/0.0.1.tar.gz"
  sha256 "dd6d79b60862db320e182475309c9dd27e63a11011603ca3876b0309e9b6ae11"
  license "MIT"
  head "https://github.com/bhagwati-web/grpc-client.git", branch: "master"

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "bash", "build-ui.sh"

    cd "go-grpc-client" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/grpc-client --help 2>&1")
    assert_match "Usage", output
  end
end
