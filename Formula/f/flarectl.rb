class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.115.0.tar.gz"
  sha256 "b82c3ed62a37aee5359b31822a4152c06b019ce43ba623f2ef7d7664bb27cffb"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(/^v?(0(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b20b75ce0237d9c51d368a7298def38a683987df7cbbd09a0cbfb4a0e37622f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b20b75ce0237d9c51d368a7298def38a683987df7cbbd09a0cbfb4a0e37622f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b20b75ce0237d9c51d368a7298def38a683987df7cbbd09a0cbfb4a0e37622f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ea3326abdc2073f6941b6b37ee334ad9856ec56c3c8b7fb41442337e0b83007"
    sha256 cellar: :any_skip_relocation, ventura:       "5ea3326abdc2073f6941b6b37ee334ad9856ec56c3c8b7fb41442337e0b83007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9eb198890281bff5996437ae186a2c9ccbaf857fd6386eb6ca7170c6a4f73bf7"
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
