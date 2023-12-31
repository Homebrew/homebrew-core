class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://claudiodangelis.com/qrcp"
  url "https://github.com/claudiodangelis/qrcp/archive/refs/tags/0.11.1.tar.gz"
  sha256 "7c074d05c891a45550be3fb3d9d085c900668f93231d58f5976b6c7081b8f7d2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "896d186a7a2f2fbe95f6fd77395250e8e4be65791c4a956d93bc547b3108d87d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5377350ed669ca082826f4826eeaa7ec63a8820d87d17bb28d081412a5f8bf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df90710a40d080165b7cce5621ac6bd9152229c1f33f71c6c9ecb7e283087e63"
    sha256 cellar: :any_skip_relocation, sonoma:         "8635c19ed69fff38411689b984d9227d38820dfb3d8d6badeaa3fc44b9d5f4bd"
    sha256 cellar: :any_skip_relocation, ventura:        "fe58ad43bad518fac17fad69f321eb2f30db0df7260ea6842822ae1dc4e6d4eb"
    sha256 cellar: :any_skip_relocation, monterey:       "f62ac8c3aa728cf4db6237125f7ac279f275413102fa327523c96029fc8c40c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "752e00903dc59480811cb2bca07dce09f7a0246580fc6cdc1ad30cdc7d2d5cfc"
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
