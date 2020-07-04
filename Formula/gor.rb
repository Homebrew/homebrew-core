class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://gortool.com"
  url "https://github.com/buger/goreplay.git",
    :tag      => "v1.1.0",
    :revision => "5cbb5ea85fcb33c40b314d8baf84cac65a623098"
  head "https://github.com/buger/goreplay.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1cc0f5704bffaefa783c86f00b93747bfc56d672456ab1500d976dc55820d13e" => :catalina
    sha256 "cdc9aa443d7e1cd5408bd9bfd4b58a97bcb1bbde957191abaa41a5ecd372d475" => :mojave
    sha256 "22acfc827f96ae4f9f7e7de5f3d3741f76871767f9656747e800a7ede3a076dd" => :high_sierra
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=#{version}", *std_go_args
  end

  test do
    test_port = free_port
    fork do
      exec bin/"gor", "file-server", ":#{test_port}"
    end

    sleep 2
    system "nc", "-z", "localhost", test_port
  end
end
