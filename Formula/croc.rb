class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.5.5.tar.gz"
  sha256 "221ebf034e05ef8c06b2e2290dfb83c6f8b4b3f8a9168d6d826b87ed3c62d51a"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f0eaa250a2850a3a0e116829abfff31a207b76a6c973f8107d34d25992938d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31f481496e7790bebb0f45994a80ac79c87abc469dcaba692d512112915e410e"
    sha256 cellar: :any_skip_relocation, monterey:       "0d2577e7b842211ca8e6efb5f7cd7d02bbdeaa674a78bb5b739d757ecacfaeb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2551feaf578982c8ea11a3b74431fccd7b87ee26eddc47e157530800d8dc3949"
    sha256 cellar: :any_skip_relocation, catalina:       "c7bf713f88ddb1cc0a5dd8db9cd6218b741db1838031b49b0d4b000731fd8b6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "324f148ed85e737248b6ff8d70880761d5f7c875a10bafa6c6f8e720da3db803"
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
