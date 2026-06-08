class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/refs/tags/v2.11.4.tar.gz"
  sha256 "2c6c751d8b5e3fe0fe35b73f37e399fa7360c6defae82d838622022dbe5de95a"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "768c3d06e0b0139abb31ff591ed8b60a3b1c8948b3c74e22f94a8eb2cee8b154"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "768c3d06e0b0139abb31ff591ed8b60a3b1c8948b3c74e22f94a8eb2cee8b154"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "768c3d06e0b0139abb31ff591ed8b60a3b1c8948b3c74e22f94a8eb2cee8b154"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5c7db4fa419c3371bbaec74b7e55e1903397bd651dd71e77f54b53047700d4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c57baa11f89e65d3d1171f47b348266bb254dc443db4aaa883a57791f1329fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "700c48c0ae8f37b2b4225c01d5f276997b232f012ac01ad7b48036c6a82163b4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/muffet --version")

    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://httpbin.org/",
                 shell_output("#{bin}/muffet https://httpbin.org/ 2>&1", 1)
  end
end
