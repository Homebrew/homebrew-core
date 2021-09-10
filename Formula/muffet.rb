class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.4.3.tar.gz"
  sha256 "12ad5bab76a736db05325dd364610760cf1098bcc50cdbab2d8ed5edefe6169d"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "627821c1ad95225d73a456d4c3ba60822f4e0bd5404699b5634eb56af3b73f36"
    sha256 cellar: :any_skip_relocation, big_sur:       "92bc419826be21bbee7680cf2f5768e4368b46a11701a1053a6ea841e3101d2b"
    sha256 cellar: :any_skip_relocation, catalina:      "37f4aa773c403efc193d991c7f79f76900ca5bd100a3a3b7741d56f5ee9c430c"
    sha256 cellar: :any_skip_relocation, mojave:        "c678701ab2c141f52b3d3a95391d5671f1d3387243c34a8d90fc502f6bda9cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "420662cb7665883a7a3fbdbd8289b08e7ed2980213727884137a5576f4edde66"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://httpbin.org/",
                 shell_output("#{bin}/muffet https://httpbin.org 2>&1", 1)
  end
end
