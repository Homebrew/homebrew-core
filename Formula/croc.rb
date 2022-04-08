class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.5.3.tar.gz"
  sha256 "7f8ac260c786bc3f1e3c577e6ac3d3e27d0d8cffa90d7a8d21cec85fe6f22abc"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f03e4ec0fbeda621b33ac5b1957133cedb22406bc85ebbfb2098357c45315cfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f732d2872f368826327114b7c2e02695b574b92a41d8bab95f0149793029584"
    sha256 cellar: :any_skip_relocation, monterey:       "8ce8a08c906e8c32484c7168622a834855c3b3341e303e624e1ef68bd53c8fd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "b09dc4d7fd14cd6b17c7ffef809b5e8bc1a39fb839e95937addae2ee6b197968"
    sha256 cellar: :any_skip_relocation, catalina:       "f523bad5c0c56567301de7800e8a5aba8a364adeafc92a59d094736ca8520315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a60285fde61871383133ccd28a24deec5b59311f20095a88a495bb220b90953e"
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
