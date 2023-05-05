class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "2bd20a90b8c2827f0553ec0e4615023629a699044d70be4910c0f8489da34240"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "215319eadb645b44cec94d3984cfe47eeed494893205c38ce6a776a45e0790ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22303568eabbb52a8094950eeadac6fa4c3cbc33c7d6bc878efa7bc4ff5f4f6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "846b24b58b42afd2c86ca109a0d7336c42dc6a8d4d500fc7373a837206f1bd76"
    sha256 cellar: :any_skip_relocation, ventura:        "1088f7a7061f474526deb4fe65ec980954fd5c045520be0457c9b0fe09af947d"
    sha256 cellar: :any_skip_relocation, monterey:       "f317fc568842ab5a0b34272cc371f7eb2f957b483ad6b5ecbc134711c8298014"
    sha256 cellar: :any_skip_relocation, big_sur:        "db74e55799902666cf7d50585320366b063ae3ad6e425a4e6531c4b2c77981e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99ce2707f8fa719c49081f3b6bc773dc9b40f4834c924d637aa9956dcd27ac51"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "GoFrame CLI Tool v#{version}, https://goframe.org", output
    assert_match "GoFrame Version: cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end
