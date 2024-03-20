class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://qrcp.sh"
  url "https://github.com/claudiodangelis/qrcp/archive/refs/tags/0.11.2.tar.gz"
  sha256 "fd8723e1f792902a1a0eff07242b2915eeec66741c08f5fa1ecdaefce607f168"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e399b37de4cb4765b937a39318ce257d7b4a540c01aaf8457f5bf5b65e24150c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6c3c05f1009c27d8f50d26d4b9e7e85b0b1dfdd434626dab846b9c3ef232059"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3113b89ea66ea60712881d091e9c9af73c4f990734ca4c58b9b7275aad73bca"
    sha256 cellar: :any_skip_relocation, sonoma:         "891eaab2deb248a2f8e7c61b8b5f373ca9a38c5e5266ef79c4a4fc8e102baee1"
    sha256 cellar: :any_skip_relocation, ventura:        "d6ff683c21bbaa22aaea15d89043dc9d2f85d3e453c68e67aaec0ccd3357e405"
    sha256 cellar: :any_skip_relocation, monterey:       "a1c0f621feb966d0de2795e1fb682a243f79b5ef6d15db770e9736683c158eab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe9c396ee041c60cc3c5872f3ae35ee4c7b4da7ca02d019bb53da3bacae86c47"
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
