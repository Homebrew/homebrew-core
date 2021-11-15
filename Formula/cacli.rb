class Cacli < Formula
  desc "Train machine learning models from Cloud Annotations"
  homepage "https://cloud.annotations.ai"
  url "https://github.com/cloud-annotations/cloud-annotations/archive/v1.3.2.tar.gz"
  sha256 "e7d8fd54f16098a6ac9a612b021beea3218d9747672d49eff20a285cdee69101"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c6cf80205658f45979413a2c281e981988c5bab3384f4eb52517b854d024801"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea0076fb8a8b30ee1809d70d1864a8cb2475f06bfb330d42968dc1775cd34c21"
    sha256 cellar: :any_skip_relocation, monterey:       "2d8eacac537081a0cb5b0f7edbb1f9711535c79b5fbc2d05e117027ccfef607b"
    sha256 cellar: :any_skip_relocation, big_sur:        "81a34b1917063bd7833e975de95940b5adff4d7b98e08d18f3f53afa61d14f6e"
    sha256 cellar: :any_skip_relocation, catalina:       "63f761d1b56137cdb4a2d94e5894c7a43ac28f8d9f7f36c2011da7ea21445c9e"
    sha256 cellar: :any_skip_relocation, mojave:         "6b8148ab93f63cc8342a2b77356c1154d875f710edceacaac4258d36d1ccb108"
    sha256 cellar: :any_skip_relocation, high_sierra:    "6dbca926050f4ca29a073d05591e818690d9a3d3cae0dffc7d658aab9afef02d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bf9422e0ae9c895130c789b2261af291f1cb4126c72a299bb2c850ecc6266fc"
  end

  depends_on "go" => :build

  def install
    cd "cacli" do
      project = "github.com/cloud-annotations/training/cacli"
      system "go", "build",
             "-ldflags", "-s -w -X #{project}/version.Version=#{version}",
             "-o", bin/"cacli"
    end
  end

  test do
    # Attempt to list training runs without credentials and confirm that it
    # fails as expected.
    output = shell_output("#{bin}/cacli list 2>&1", 1).strip
    cleaned = output.gsub(/\e\[([;\d]+)?m/, "") # Remove colors from output.
    assert_match "FAILED\nNot logged in. Use 'cacli login' to log in.", cleaned
  end
end
