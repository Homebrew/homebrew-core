class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.17.0.tar.gz"
  sha256 "b61ba285f409d3d96bb35ced7431b6b4a3244996e24a8e3be465bfb878fc1f7e"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "79c9923bdaef9f977e70e3ba0b55b232e03b3f1868bba1105345ea400d9e2949"
    sha256 cellar: :any_skip_relocation, big_sur:       "d7ef979d8dcdd7f3ea2c59e3472e496d82e8ef7563d17bb62bcc794ff352dcb3"
    sha256 cellar: :any_skip_relocation, catalina:      "6c332f9cdfd7c99128f89c088671823eb8e926e8b8d0bf541dc0de5b015dabd9"
    sha256 cellar: :any_skip_relocation, mojave:        "dadaec4b4d2a249ce82a97d190bc8629f95ed70dc988a130a6071a47f7e409e3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "HTTP status 400: Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
