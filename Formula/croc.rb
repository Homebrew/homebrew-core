class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.5.2.tar.gz"
  sha256 "9fcbb82fa78122b0a2279fe9b4c4c7ff6af7b0599f275c04481ad5ed162d2952"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14738f9209fc7804b573dd4f52ddba639b135deabe73162da5518a6cc6257555"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57a03a4fd674c685898663aada05fe98860482157ae116c830e60f10bca7547f"
    sha256 cellar: :any_skip_relocation, monterey:       "2c5887dd333a03cec56177aa9fbb525d3c52d168578d4854e3a008e58e5f7baf"
    sha256 cellar: :any_skip_relocation, big_sur:        "72043a3ca87aa2caf46f663f3d82e046ddbd56fb26997c6d0137be65163b06ee"
    sha256 cellar: :any_skip_relocation, catalina:       "41aa72dbb10e71666644841a4ebaefc2578969457154208e7e8fb6ab93ca2db0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b74d2fbc395900aa4642e47e850bf6e29cea8aa6555ad1c7895af7fd00a5f195"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port=free_port

    fork do
      exec bin/"croc", "relay", "--ports=#{port}"
    end
    sleep 1

    fork do
      exec bin/"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}/croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end
