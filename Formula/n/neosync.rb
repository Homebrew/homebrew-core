class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.19.tar.gz"
  sha256 "a1da4288c8437efadec2fbfe3c7d82ffc3672c08eb0dc357d0d38f6e7fbe2aa2"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "808bdd7fc443bbc6d5e341b82b6ee7e0ba5994b07d5b079d2e1bb82f737aff0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52a486a4b630fcad558511a936d5e21bce33cef7c9edd3bfaa4f4efb30f66c25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97d99c342cd065febb761cefa9af9554cc6c8aef986153516f81173663bddbfb"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b6913dcaf9ce7f895507bac71442716ff02f0cd2ec87527d01aa77c9ea535fb"
    sha256 cellar: :any_skip_relocation, ventura:        "702b1e8d871565ff995866280e38231458ac1b61de6c16aea1c269465ec550d3"
    sha256 cellar: :any_skip_relocation, monterey:       "4d88fdd480559bd118c70973991e6558dc014724022dc63fc4560546314e32c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ed81e5d392b7c6a9dee7e33752d24f30f3cf5d03e4ef29a503292e311788d32"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/neosync"
    end

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
