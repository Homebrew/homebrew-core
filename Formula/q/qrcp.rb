class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://qrcp.sh"
  url "https://github.com/claudiodangelis/qrcp/archive/refs/tags/0.11.3.tar.gz"
  sha256 "de6a9e29d7c71268e40452abf2f1f593d5d53baa34df5abcb7352ebfd72a952f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1412bb71cdbc83ed8be54281f08cbb6b0abfe379c8b39b1b72fc781941a27d5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2a1feee6e390e192dc3c9750ffab42cbb99282ed024211f2d8f34ed1b6d290b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2a1feee6e390e192dc3c9750ffab42cbb99282ed024211f2d8f34ed1b6d290b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2a1feee6e390e192dc3c9750ffab42cbb99282ed024211f2d8f34ed1b6d290b"
    sha256 cellar: :any_skip_relocation, sonoma:         "889feb401afde85d10a584249efd64810cc7c6a28de0935b2c70ddbdc4abeae5"
    sha256 cellar: :any_skip_relocation, ventura:        "889feb401afde85d10a584249efd64810cc7c6a28de0935b2c70ddbdc4abeae5"
    sha256 cellar: :any_skip_relocation, monterey:       "889feb401afde85d10a584249efd64810cc7c6a28de0935b2c70ddbdc4abeae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c8ae9e3c53ff4f2483f61a75bb47e7a7d7ae1924116229f68b9bf9d78f4806d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"qrcp", "completion")
  end

  test do
    (testpath/"test_data.txt").write <<~EOS
      Hello there, big world
    EOS

    port = free_port
    server_url = "http://localhost:#{port}/send/testing"

    (testpath/"config.json").write <<~EOS
      {
        "interface": "any",
        "fqdn": "localhost",
        "port": #{port}
      }
    EOS

    fork do
      exec bin/"qrcp", "-c", testpath/"config.json", "--path", "testing", testpath/"test_data.txt"
    end
    sleep 1

    # User-Agent header needed in order for curl to be able to receive file
    assert_equal shell_output("curl -H \"User-Agent: Mozilla\" #{server_url}"), "Hello there, big world\n"
  end
end
