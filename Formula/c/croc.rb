class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v9.6.10.tar.gz"
  sha256 "681a8e0fb70ec7c759c55dcc452b519de601358773af06ae6496a23eb95624c1"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83e2b133feb1f49529a40f0a0fc28c4dfa35654a569236ed6146ea3923ab3c1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5c0dbe62c239c0c33be27f6a677efa84e745dea7afcd21040a9b15fe0a1594d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47d8ae4fe2d39b9df4abf5e61e9bf0c9c382a56573ff7f2c4c19dd0322dfe1f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b2106de9613028aa4bf2ca5390d3c6bcfb255a522d93c9565fe49bfa1f8d00c"
    sha256 cellar: :any_skip_relocation, ventura:        "754c9307fc578897ce98c14c1d9ef6cd67a20429c696a53e1dab4df8e6e4be84"
    sha256 cellar: :any_skip_relocation, monterey:       "6786fc3f87f7b56e6b56639c89b8d4adc22ecba00a487c68dc67db0bbf50a57a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "473589cf16fc507af09bf41fc84e76acf8af666ccdf1a75b8d2dc8432c007dfe"
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
