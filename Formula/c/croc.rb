class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.6.5.tar.gz"
  sha256 "2d3ba7bae3c49e3870e2f8523c6be00e92fe6e46828269a8cea34d4034102cad"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34be7a4340de866aa4b1f883cdc9604a30d1ceea355d38cad459986377964766"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34be7a4340de866aa4b1f883cdc9604a30d1ceea355d38cad459986377964766"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34be7a4340de866aa4b1f883cdc9604a30d1ceea355d38cad459986377964766"
    sha256 cellar: :any_skip_relocation, ventura:        "b22e747202aa670bbbe75d68e618cda3fd1fd595d93391f14f38ee5b42e78aad"
    sha256 cellar: :any_skip_relocation, monterey:       "b22e747202aa670bbbe75d68e618cda3fd1fd595d93391f14f38ee5b42e78aad"
    sha256 cellar: :any_skip_relocation, big_sur:        "b22e747202aa670bbbe75d68e618cda3fd1fd595d93391f14f38ee5b42e78aad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "894d52ea147115cf2fc1109b3bfd3349647546d12a2191b20a95d92369d1066e"
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
