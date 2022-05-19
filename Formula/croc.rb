class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.5.6.tar.gz"
  sha256 "c03c7b9daf2ba841d373d9c43abb68dc27ab1d7e01bbadead771918d499dea9e"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ec01223ad398c0175b91d479bbf104554cdfc2c80e47f1ffcc497f4a751fa05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "632be9cf99502f5d75560b24bc6aa50ae2a63ffac577cb5f3bcafda9624dc440"
    sha256 cellar: :any_skip_relocation, monterey:       "96744d61748320553e7e6568b778c06e4471bd54634c710a56ddad84ff5420dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "81ea8fe13f1732a3ee02ccacfc370e16551a46b19b595824cd6f0a676cc33cae"
    sha256 cellar: :any_skip_relocation, catalina:       "f9f24a512f5391c6c8a1af72645aeeb467a28b59682279517408631145274970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a82770fc682256696a5811ba7fe5ad841370d9925133a0f5123b9e7c9de6a56e"
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
