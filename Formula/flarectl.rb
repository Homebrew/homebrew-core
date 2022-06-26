class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.42.0.tar.gz"
  sha256 "9fe61ec4c585fe9b2a6ecb1dd132108ca2cec1d2f497063436664654d03a7604"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af5e6a911e732edd0142c3b55bd10443c0749f8e9edcb0b0f85618c3edaeff39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ed10380aac124bdbed73153a21c123622e516abfb8478fb08495ab8047d832d"
    sha256 cellar: :any_skip_relocation, monterey:       "48b35308220050f6363ba569486eace7d96215e4813f4e2f7491ed2749dd0527"
    sha256 cellar: :any_skip_relocation, big_sur:        "f109f9542c8bbebe1dc562350dbb806b14c2ce28b8bb4667fdafe89b20a30f11"
    sha256 cellar: :any_skip_relocation, catalina:       "8edbc18f0c1ceb6a75e128d36a1bb3ecd95f9437b52a59e55feb266e3100f359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb10b5fa8c45b6e90050f32c8d1feecf948e3835de471a114a67b26fab151389"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
