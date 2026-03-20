class Q < Formula
  desc "Tiny command-line DNS client with support for UDP, TCP, DoT, DoH, DoQ and ODoH"
  homepage "https://github.com/natesales/q"
  url "https://github.com/natesales/q/archive/refs/tags/v0.19.12.tar.gz"
  sha256 "1f56ebfb93fd380dee734cca9227149de2491c49db7b2c0f21019fd463081e4c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee4dc8a277a2ba2978c43366c9ed1cd0410ca58b89f3950dc8f09cf6d09a85ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee4dc8a277a2ba2978c43366c9ed1cd0410ca58b89f3950dc8f09cf6d09a85ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee4dc8a277a2ba2978c43366c9ed1cd0410ca58b89f3950dc8f09cf6d09a85ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb9e47d8a8ef45e3def47976940c9e3a7604991198e247dcb706c7dc1564a45a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87fed670b4705b13beaf7806b77d8f87bea6738ea8beab96e86c1f0d0a8a9b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49cb138a5a2993410b7ff3866a8088ba2cab0fc1fbd9ed56bbf1b9f987eb23e4"
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
