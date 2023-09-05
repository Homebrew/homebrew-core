class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://claudiodangelis.com/qrcp"
  url "https://github.com/claudiodangelis/qrcp/archive/0.10.1.tar.gz"
  sha256 "866344c247fbc2bd4def91e2b7fe395b81bc954b89dad4f32ebd8033bd2e6c7d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb8411ed58cb46bf657126dd96cde64faef4fc2f659bfd83007e68b890ebee4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb8411ed58cb46bf657126dd96cde64faef4fc2f659bfd83007e68b890ebee4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb8411ed58cb46bf657126dd96cde64faef4fc2f659bfd83007e68b890ebee4f"
    sha256 cellar: :any_skip_relocation, ventura:        "a124631223cd27aebd64b75466a4ff7d982c327003bb37088c0d1b310d4702ae"
    sha256 cellar: :any_skip_relocation, monterey:       "a124631223cd27aebd64b75466a4ff7d982c327003bb37088c0d1b310d4702ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "a124631223cd27aebd64b75466a4ff7d982c327003bb37088c0d1b310d4702ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d56dba0ceb4cf3b57647e788a777e3fec8bfc4141f68cd8f1ada06354f183cb3"
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
