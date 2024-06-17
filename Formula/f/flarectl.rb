class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.97.0.tar.gz"
  sha256 "4c4270dfb0b3114ccf76dd7a8354877c106b79c9216c9bbaeb3e784e484ad1ce"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(/^v?(0(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1c53dd4461966a84b70161554c520550a77044fa96d8199bd926d0f0ce4abf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b1036632b065b6d7cee8594044c4c773b2d402316e20ce6014a04843f5ef793"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1400616fe7906e93668f25b1ec8be24cb67db8c920d5c539c77353e93cdfed97"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bcbd276c4b83a2ee9e0ace5ec6e9edc8fe45e5e2a778ed67ed869c3045f81ad"
    sha256 cellar: :any_skip_relocation, ventura:        "e52db186dbb0cbea25fec215699d1ff971d83b5a48a99993f2c826ad14e02a71"
    sha256 cellar: :any_skip_relocation, monterey:       "22c5e7bd636ada489470d99fca3a60a21d8f5ab2cea3b7f54e2acfe93b112183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e981198183d5c05d13e304812210301f6522e548bf27b1610b13b43aa7b217a"
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
