class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.114.0.tar.gz"
  sha256 "fd49cd98df473a0afd036b4c2916be47b7ef9a8784a6847447fb7e59f2e1a107"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(/^v?(0(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "508087b68577e07d5b1eddbd5cf337cf004de8b00e7adc96c1f4965dfd96fe4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "508087b68577e07d5b1eddbd5cf337cf004de8b00e7adc96c1f4965dfd96fe4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "508087b68577e07d5b1eddbd5cf337cf004de8b00e7adc96c1f4965dfd96fe4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f649a122211214dcb1b184306b59e04a90b9abd26bdeb63b9f249e415bd28c5"
    sha256 cellar: :any_skip_relocation, ventura:       "3f649a122211214dcb1b184306b59e04a90b9abd26bdeb63b9f249e415bd28c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f6bbd22c06fba3d476e7818e7b89cacde713f5a11c377b08449faac25ee39d0"
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
