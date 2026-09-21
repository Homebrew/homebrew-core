class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/v0/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.118.0.tar.gz"
  sha256 "6aa2194c7c6efcbac373e42e9130a03db4a515fe55e3c24406f748f93808e8d9"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "v0"

  livecheck do
    url :stable
    # track v0.x releases
    regex(/^v?(0(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0a99d7df99dd1b4f1f5703372815fa36e3a46ea4f68886eb3f887bedd6a1b26f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e75eae27a3173ecae8d931d8893dc33e2dc5266b6c2ce8a4ee796d968888df0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e75eae27a3173ecae8d931d8893dc33e2dc5266b6c2ce8a4ee796d968888df0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1e75eae27a3173ecae8d931d8893dc33e2dc5266b6c2ce8a4ee796d968888df0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "53fe294923b1eaec575fc7b074fd945beea8b1a5375670de79acb979f3f72499"
    sha256 cellar: :any,                 x86_64_linux:      "f0c88ca45ab7181042280bb37895e9b0798a66020ae8c8b926031f8adca1929e"
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
