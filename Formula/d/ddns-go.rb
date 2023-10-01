class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v5.6.2.tar.gz"
  sha256 "ac74c1ef96688838ffeab18dd011616b49b156c533cecf859eeee01e5c1a6e40"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b51a9782edfc05e62481ff481f797288d5f4a2b7a06bd02c07fb888ec7bbe1dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f67e70049d7ed8f1b62331f4cf1494b23f0622d4949d63c66ebe69e680c53084"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e9e4c8785ea4b2cf78a6f89c6c0a8c7ff1e82fd150341503d73e297cbdf3fa5"
    sha256 cellar: :any_skip_relocation, ventura:        "08e33e0850eeea30860d88d89b42e7e6471da9cc349147960a810bd6404a9f6c"
    sha256 cellar: :any_skip_relocation, monterey:       "0a60e2e79dc5d6299115cab856b8a992ef29c5383eaa460064884315d0c0a414"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff55d7b9c4cab0752e9d6ae40e74676103d1f683d0049b767134519c6fd074c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d0ef4f9a3c8a73034862c8fb59106bbe0c3ef55a0ff98067d6962b7b4dc8997"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ddns-go -v")

    port = free_port
    spawn "#{bin}/ddns-go -l :#{port} -c #{testpath}/ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}/clearLog"
    output = shell_output("curl --silent localhost:#{port}/logs")
    assert_equal "[]", output
  end
end
