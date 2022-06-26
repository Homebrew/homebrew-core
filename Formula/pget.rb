class Pget < Formula
  desc "File download client"
  homepage "https://github.com/Code-Hex/pget"
  url "https://github.com/Code-Hex/pget/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "34d674dc48144c84de72d525e67d96500243cc1d1c4c0433794495c0846c193f"
  license "MIT"
  head "https://github.com/Code-Hex/pget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "161dab036f92f8ed27d33852a62f0702deedf2c862ab59f00a5dc79c18c165bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ced15f422006c330d99f63db09a0263f6001d67308381cac67cbe59bd4688e84"
    sha256 cellar: :any_skip_relocation, monterey:       "73838f1c861df1e0db812a511a9bd83074bc3934b8271c0d07259acca99bd013"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3634ac25b2f88d3c25c0dc431560520dd3ee1d200c20731efe87374e8597263"
    sha256 cellar: :any_skip_relocation, catalina:       "b1b8f24e110550393b67f7b079c345c9622970a1fb304c4782ec61e9aafe918e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8f774d4539a1ebb52d217dfdc936eca88d839454f4d5581b3c015eb9f6cc093"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/pget"
  end

  test do
    file = "https://raw.githubusercontent.com/Homebrew/homebrew-core/master/README.md"
    system bin/"pget", "-p", "4", file
    assert_predicate testpath/"README.md", :exist?

    assert_match version.to_s, shell_output("#{bin}/pget --help", 1)
  end
end
