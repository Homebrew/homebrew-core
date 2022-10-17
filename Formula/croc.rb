class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.6.1.tar.gz"
  sha256 "a7f0db2b52e44358beb2782412c955f2d5a63da72832b83de48739b1431cb19c"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ee8bd0a5c5172e954005b469aa8de3f288cffdd973a1791fc73d12156bae736"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0f166c9ddecc9ef346e5ea67c4d6c4412d7e18473c897ebabe67cff54017867"
    sha256 cellar: :any_skip_relocation, monterey:       "dce32b114c07a1c8888f2b9192b8ed859cfe5960f60093d9d74fe96891c88265"
    sha256 cellar: :any_skip_relocation, big_sur:        "d457ebb50c1c87f8e02c827d8f6efa266742f8ed4c78f523a4f436970d28c3dc"
    sha256 cellar: :any_skip_relocation, catalina:       "6360069a7a5ab720288da36d21a08b27f8ec1f45c8a9eb76212acbdce86c1717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "168843df2a894a84a4e106ea3f7875e3015f4e3edc5b0cbeaf1ad6f7b25f71ea"
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
