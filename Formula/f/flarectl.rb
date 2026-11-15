class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/v0/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.119.0.tar.gz"
  sha256 "96592a5ea285ec198a6557618131bf502d938c3a3105b7dbbd9e01677fcb8abd"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "v0"

  livecheck do
    url :stable
    # track v0.x releases
    regex(/^v?(0(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "634d8db04e95446faa40475897c2cf60e8684ee6908f18faf7fc4494d118aa2a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "634d8db04e95446faa40475897c2cf60e8684ee6908f18faf7fc4494d118aa2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "634d8db04e95446faa40475897c2cf60e8684ee6908f18faf7fc4494d118aa2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b536762049b9ec69827a388aced7ff2492cb581af7f334ef754fd76a1f9bfe65"
    sha256 cellar: :any,                 x86_64_linux:      "1622b344a715b8cb3fbcc90077b65799b8355149e7e277d91312961ab4aa702b"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
