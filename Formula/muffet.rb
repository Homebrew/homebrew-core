class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.4.9.tar.gz"
  sha256 "b8efbcf3b04db809a28625603612924f8b587fce5993b85de0cc9d3cf8b68e40"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d645af551cf6ac8e8f3303f6473fde6e80595843c003b7f3217a1d1be9614c20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a016741345993a6acfe701c687fa94652b0f91aa733461ad0d4fbbdcc3adbe8"
    sha256 cellar: :any_skip_relocation, monterey:       "c6a75fcda18098c883eec4e702a50d7a130f5a571a5b5537c04e0843217e9791"
    sha256 cellar: :any_skip_relocation, big_sur:        "33c5f38df044aff19bd0a0623770e0d099bd725ec31cd2a91eeb84bd94b09264"
    sha256 cellar: :any_skip_relocation, catalina:       "fe5e809693933bf8335a54196e575381b6d9960935ae6ea87726cf05736c47db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e4d2b84eddac85126f5f48ed8a4d20d0b761f115a787e91e1e576368cc4656d"
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
