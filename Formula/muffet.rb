class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.7.0.tar.gz"
  sha256 "230e0622c07a00956da25b0a79f71056a7cf251aaa2e4714e9a618a237c9b12c"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3399c577fa1d0a2cd9eacf50f44f9e36f5df3ed8d776046f819d8859d28efd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd104eeeb8cd1dd1404380d9956f92d7ce1d6eb8f858b65c7adfc1ae8632d876"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff448fdf9c8d60ebb5dbdd3eb4db3dc0812f30b6b3b12b910fc5a183468af6d2"
    sha256 cellar: :any_skip_relocation, ventura:        "5b2e9e4403078581ee0ab01d2f99197d4e1c720f76ba394fa34a867d8fa7aa1e"
    sha256 cellar: :any_skip_relocation, monterey:       "aaab4287f8dd3a5c41edee89ba6eccea756c71dd78beb59d27f41834ba090a66"
    sha256 cellar: :any_skip_relocation, big_sur:        "4809499f184b22cf5281af80c0e01e37280fbd5c657c4f61b53fdcd1b90a10ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b09363a25177f4da7566b2472e6d6e2cd21ef4853fbb4753a7c180f6980950da"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://httpbin.org/",
                 shell_output("#{bin}/muffet https://httpbin.org 2>&1", 1)
  end
end
