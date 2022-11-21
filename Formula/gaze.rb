class Gaze < Formula
  desc "Execute commands for you"
  homepage "https://github.com/wtetsu/gaze"
  url "https://github.com/wtetsu/gaze/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "e954f074bcd3e7f8c898bf83faecfe5f2acff7001f1001157798c9e723916aab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ab075f07c65efaf0e8faa3ddce49e8a4877ae2b966cfead7a60e1e21d88a070"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c4c86df3793fb3de2299b319ffb0de635271c379984a4309de974ec3fa0c8d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22c3be1483cbf3bb3f454c4ed2d7124704720c1e3474873f2cb5cb22fec915c8"
    sha256 cellar: :any_skip_relocation, ventura:        "2fbb08d1ddbfcfa42571e858e18a43201be7f008f2c84726b63a355744745aee"
    sha256 cellar: :any_skip_relocation, monterey:       "5f68fd64a2c7ef1afa4e1385dceabee5ff4ca4cda55285a130f568cb7165a466"
    sha256 cellar: :any_skip_relocation, big_sur:        "b91176a3baa7c9c4713144fe051083e77a7d71f111eebd8d7eeaa60e3e1db15f"
    sha256 cellar: :any_skip_relocation, catalina:       "cb50d130b59682afd539e3aa24dd758262a00c0e834e49eb79d7154039df74aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "466f803a6e2c83373c189248e2ecbc9eee95f7cc2ba6887a43609c6677ae2cff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "cmd/gaze/main.go"
  end

  test do
    pid = fork do
      exec bin/"gaze", "-c", "cp test.txt out.txt", "test.txt"
    end
    sleep 5
    File.write("test.txt", "hello, world!")
    sleep 2
    Process.kill("TERM", pid)
    assert_match("hello, world!", File.read("out.txt"))
  end
end
