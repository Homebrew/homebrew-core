class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.4.4.tar.gz"
  sha256 "1dac63a5019b4df60d0884a1a88a79276962939d352a8ff14c8b9be65d173bb7"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2921a8a2e676c7c1115a265ac044aa9e33894888b97c9f1f76a8895e2b9ef63c"
    sha256 cellar: :any_skip_relocation, big_sur:       "78d43985a2b6d53ab1ab4429e09ddd116de471827fd84ed8582acdce55fc56f6"
    sha256 cellar: :any_skip_relocation, catalina:      "64bf10cf727e8911f84f634f595799083f13f7bb23e451d18e83b7363d487303"
    sha256 cellar: :any_skip_relocation, mojave:        "cef2471a38064004057e5fd4521925f10cfc68ca6a5f0ba86285b378b9e08e6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bedfaa6c6fdb224ae529ef386066ffcf336b56d4c81fa97a8e07c67f5fbf4c6"
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
