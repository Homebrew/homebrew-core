class GrpcClient < Formula
  desc "GUI client to talk to gRPC services with integrated React UI"
  homepage "https://bhagwati-web.github.io/grpc-client"
  url "https://github.com/bhagwati-web/grpc-client/archive/refs/tags/0.0.1.tar.gz"
  sha256 "dd6d79b60862db320e182475309c9dd27e63a11011603ca3876b0309e9b6ae11"
  license "MIT"
  head "https://github.com/bhagwati-web/grpc-client.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "npm" => :build

  def install
    # Install the main binary
    bin.install Dir["*"].first => "grpc-client"
    chmod 0755, bin/"grpc-client"
  end

  test do
    # Verify the binary runs and shows version/help
    output = shell_output("#{bin}/grpc-client --help 2>&1")
    assert_match "grpc-client", output
  end
end
