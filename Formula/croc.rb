class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.5.1.tar.gz"
  sha256 "84bc80900c90d3b3ef0fd9590b9b839c876ffa15ec24ebf230c9a979c4ef5188"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d4a6844efa1fbb3b3f8119811623011169f51ace584c1e7fca2a923a44b0790"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8baf3e57c88833beca0178261add1deff5a3fe82b0b32d16a7b8a42ab094ba3"
    sha256 cellar: :any_skip_relocation, monterey:       "65bfb32c4f3d78e31634a70d727dd6bd02031d9d06297eb103635d8354a7f176"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b9032a10fbfd7b4daa5f76f32b984a5d5763290c13a66e2f50aa6f623abe1fb"
    sha256 cellar: :any_skip_relocation, catalina:       "0da9dc6a158a7203e95a0c49b9a53f9edfd2170c8904d8506cfdea55b61995f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dead30b55354c5b8308f76ca00fc1a44d9b89965f4f6424a8a0b564b5dc1479"
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
