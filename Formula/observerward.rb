class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.8.25.tar.gz"
  sha256 "c2ccbc57c3e2ba85bc17908d4af3fc710fc619a27a16c48b8eb0e3a8e465f803"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e39d99aca455fab3b2291e5dcbe3b80fbd5182cb93229cf8c9fa0011f0f84527"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d38cf95d3dd4ea81496ac9dedfc8fc5820e2892a2a7006d08c54e2fad5617ed"
    sha256 cellar: :any_skip_relocation, monterey:       "cfd82a4b21130686f2e500233a72b1aef3919e8ff7910d1dba06cdb10a0639ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b6fade7a5efe8b365acbbaa87129a7455cebfc3443951dfc5da6ffcb7b0cc60"
    sha256 cellar: :any_skip_relocation, catalina:       "478962e2730b4bbc8510623c3ea9830f3cc171c5d8d1d805618f523e80f1dc2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d4d31cd0aa86e27c8737f8b5e1410a60011ba7da0e65799dbdc21a4439730c5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "swagger", shell_output("#{bin}/observer_ward -t https://httpbin.org")
  end
end
