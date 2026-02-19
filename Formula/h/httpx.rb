class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "063093ba08409131a2b760807ddaa65ea7b42cc2e9fd3fca6ba32c3d94b6ba92"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb053ee31728725df8445811dc154df8fc618c9e912d6a4f8576288c896fab61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66f75f921084e2dd98e02ab1e9fdc8c7fcb1f2b52636e4c970a978a59db927ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e430007ad651f3c52838fc563549add7fba7cae3004f2067824f7f73a924a1a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9afaef26fb2013693302949b43f13d60ea4e8be35cd87ae8f81424b4baebae0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba657fae0927582e8d90c315c81a956c8be73321bde3363d0cb62b3eb36188ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32d26892b13133b03906d45460228c11f8ab8cf15a03ff169a75904626c6fecb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end
