class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.70.0.tar.gz"
  sha256 "78ceb8fdb2c72f4e142e3b6b463635df4c31730b9edc5f1bbea9def080d7f2fd"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc410d66523bdc742e6ab7f313bb01f430b29ef99bfecd5d0005fb39d5cfc946"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc410d66523bdc742e6ab7f313bb01f430b29ef99bfecd5d0005fb39d5cfc946"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc410d66523bdc742e6ab7f313bb01f430b29ef99bfecd5d0005fb39d5cfc946"
    sha256 cellar: :any_skip_relocation, ventura:        "043bf7bb701dc2117bd77611cfb8e8340279121ff03ee534c279ae0f764547f7"
    sha256 cellar: :any_skip_relocation, monterey:       "043bf7bb701dc2117bd77611cfb8e8340279121ff03ee534c279ae0f764547f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "043bf7bb701dc2117bd77611cfb8e8340279121ff03ee534c279ae0f764547f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52d768c02a88db992acf194c015b31cc5ae278f0ee50dd9db8c6a62d0d717d18"
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
