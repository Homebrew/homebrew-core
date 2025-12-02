class Q < Formula
  desc "Tiny command-line DNS client with support for UDP, TCP, DoT, DoH, DoQ and ODoH"
  homepage "https://github.com/natesales/q"
  url "https://github.com/natesales/q/archive/refs/tags/v0.19.11.tar.gz"
  sha256 "c13dbb556f2eaa26c7bd66632a3ced4026f26486f6563104e919e3cc6d7776ce"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bbac230fbe1216a79cb25f4e55d778869cb5160da6c65a1454f480afbef2f9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bbac230fbe1216a79cb25f4e55d778869cb5160da6c65a1454f480afbef2f9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bbac230fbe1216a79cb25f4e55d778869cb5160da6c65a1454f480afbef2f9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "69816bc204aff5b77fdeca09ee8ac8dda2c2d5d4cd5a81cb20c67cf71b3a3478"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d55c7d3c75e356b3ae9cc2a9d843866e17d784955a2c164ca0fe99089412a1d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37721216eacdfc504746d78a25a13c1dc77ac8debc758e2a624e0abdb515ac7a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/q --version")
    assert_match "ns: ns1.dnsimple.com.", shell_output("#{bin}/q brew.sh NS --format yaml")
  end
end
