class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v9.6.14.tar.gz"
  sha256 "c8b1a109fcf496a103b8d70ef76c0ace6ef22d5575be6bbe2f571c6b1fe6a8ac"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4640f12292cdeb5e042c1a7c417e7805e0f3b99fc50c5850e67fd9fd31fcd623"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc068b85a7add5ede792e5f974366813d5350e9aa1ab41ce0c67854d9ede0c83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "615bedbc6601ccefe817496aec8c0f5cf166c44c8a270b8372f9de5dfe3cf5fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "e425da9d6dcb775fc7761524a4d1d4ed066e3b85fefa150af4019b7de1868bc1"
    sha256 cellar: :any_skip_relocation, ventura:        "0c1cebc6d4b0d11efd1af16c566fe8a2222e0f1a81a8c2459f7ed62f1831a905"
    sha256 cellar: :any_skip_relocation, monterey:       "c60c74bcb65d268dd62cec0c374ffbb90c42f429ad3b6168482ad58a0697bca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da7c7206910f2ef834e70bfcff74466d7580d29bdabd479fb73eb6b967fa897d"
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
