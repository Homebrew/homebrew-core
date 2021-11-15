class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.4.5.tar.gz"
  sha256 "370c8d5d179f0edad4cebd1fe5b27b87dd19014f982c5b1a17fd34b7a07c93f4"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2137bc34e12dc72fc4d5a76ab41023047edbb8794c54a275f222c98ccb411267"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "587f77543f011b1e1689cf82510a7981f9ce60d90f86b157154c54bbb6a89161"
    sha256 cellar: :any_skip_relocation, monterey:       "0ce4dc6355ec1f7dd16cdb26702e5fc0ed95f3258b59d9070a53c757d0b89d78"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7b52ecac97a6568099bd6caae059bf562ccbdb3847353a609ac2fe1ca04c2d8"
    sha256 cellar: :any_skip_relocation, catalina:       "a1a9820378576b8b48e553e30e8f857ffb37ff191208d9ce594681fb4b36ecb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "619e0cd7ebcd50c79cba3ca0ad75797975d88673a517e1c7383f6db0afc0404b"
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
