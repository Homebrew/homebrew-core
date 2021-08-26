class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.21.0.tar.gz"
  sha256 "3b4c82c526c26d20db76f16adcfe671cf4d4616e7680ef6798ae539775186417"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "69f908570ab55ff781d572295fb1484907c7df26554fe5ca96d69e44269adf95"
    sha256 cellar: :any_skip_relocation, big_sur:       "d797f82595302d4240955988835ca23ab59a8d2894995667110ee8e5dd8392fd"
    sha256 cellar: :any_skip_relocation, catalina:      "6ad60831572fafc18c5a89a52acd0ed76a858d69372eff819d2a90fe54f3da05"
    sha256 cellar: :any_skip_relocation, mojave:        "b9f01eae281325c595e882a023ee4d2c5a1445c330a6ba82060e2c4cfa47668c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0047137a5fefe80aecdb60ba6aa28f1e70b5a2361d7292bc45d77511b920d16e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "HTTP status 400: Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
