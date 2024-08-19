class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.102.0.tar.gz"
  sha256 "b555536c51c7c727a102059146df3f39c3991f27151822064630cfc938a372c3"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(/^v?(0(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69a569e2146b56dd05daf6faf756de07b52c59d854a0784da3c77e6a4aeaecd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11bc1a10712a0ab929716f22d92fc78f773241bf72aa6fb2f321073856ba4f1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15dd810b32ae045a713ad2ac9456a91556ebb02ab1d907d5297d88a0afc7e2ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f42c33042bbb9eedd71af8174da261754039ef0230be83ae8b65d87b6ff4bb9"
    sha256 cellar: :any_skip_relocation, ventura:        "fa557a46fc4f1e06df1f47fc81c43f7f023a7d22131611fbd1a0131cf5bd6700"
    sha256 cellar: :any_skip_relocation, monterey:       "626d1b849f5f8e9c74106e158ef7f3e128104594ab3f149a5939ef8b1c108dc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63b52bfc6592d9e92cf9fab452f3f8bd9e97a9753d63c2d25ca26b42aed3e749"
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
