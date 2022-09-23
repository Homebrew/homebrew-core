class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-5.6.tar.gz"
  sha256 "6cb2a5f4ea6fc57a339aa8d7f21636c4889579cb418a8843c53cdde5dbb9c3ee"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "714228afe2a3b99b4f54f9c98a825e33d69ed40a51f02c77418b012a7a6ec8af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3c2213f827ec4718fe73395ba31f52ae6857c6fa42ba25bfec78569f1c02f66"
    sha256 cellar: :any_skip_relocation, monterey:       "828d4b67d6293d3b1ae58d93846a21b5fc65370b4c1f2a1cfa9c0636a03bb3b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "75efe0fabe1441e2b4dd6f59dcf75d30eda2454a50a31c9eacbced068a0b8324"
    sha256 cellar: :any_skip_relocation, catalina:       "cbfd6d5b06298bfe8019f5418b221a2fc7bd20fc110f86c0abbf975716278175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a5807e801b2b9422e67da3fefe68b52e5a1949281771d427572ec38049bb484"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./lxc"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]
  end
end
