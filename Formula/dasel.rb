class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.24.0.tar.gz"
  sha256 "ab8e8433a6a72f842f83868940e3010755fd2572f83288a2f4a81b50bb7a92e3"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "433a1caf2b931621426f0366290fe6d22c0569e91c2241736bef645e223c0b50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d9a16759b9fe89663b33693f927dc3aa207936bafb1ffb124eaa64a1ec9ac10"
    sha256 cellar: :any_skip_relocation, monterey:       "dbd98761e42c74f1c20bf117af35d96c665aabe68c20352130c49ec3b7a72c39"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e43b81b1ac3b9a8dac0525e68b2928fde85e08265db27486c38881689bd30bf"
    sha256 cellar: :any_skip_relocation, catalina:       "62615dc6621b467ed0965b170e16b9702909f7756cc600adf182dd7102d3958b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e457e8f7cae5e98ec52be8d102d5992e984a62a7edf1150161f308114a73399b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
