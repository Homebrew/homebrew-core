class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.13.4.tar.gz"
  sha256 "6b5a9b3fc3176fb481d71f6c7aff2d505c3dbf624f044c19ece131071ed387f1"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8455b87e282dcd70c9f1cb7e56d5d76c385cfd8737614d63452ad70ec7dd4936" => :catalina
    sha256 "348c6a2e2b0a20fffd2e1131dd2d2997811bcd2ad55799bf6514b5955ae2e62d" => :mojave
    sha256 "e56a99546a4318394a6cbddcf0c27f96f346bae73c03fca1232f05b8ddaa671f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    cd "cmd/flarectl"
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./..."
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid format for Authorization header", shell_output("#{bin}/flarectl u i", 1)
  end
end
