class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.12.0",
      revision: "6437b3c2db0dd3c1d6c76cb71d784c874b185d01"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f865fd2e208c54287fc482a6899446249904a61e693cf69eef4bc125db9105e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7698aa5d4946d44d8fa201ff14b6924e75b3bc0d0b700ed78dcf15072beff0b6"
    sha256 cellar: :any_skip_relocation, monterey:       "f42c269957f2fa61ad5380fb6c9ac21b276ea7e5c2e2c61ddd704f5fa266e7f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "3907c1f8a34993b688770f2fc978e27c74d10ef379d595e803c3ba90c3d5039b"
    sha256 cellar: :any_skip_relocation, catalina:       "2fd0999f639c5b5b7f4b3381908a78c4a19a4d4be8d07a2f312a3e20eadff180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "947b757616db2385ccc33f575e1cac39192483ba23fcdab8a6b4aac559811ff2"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps")
  end

  test do
    assert_match "it does support HTTP/3!", shell_output("#{bin}/quiche-client https://http3.is/")
  end
end
