class Cacli < Formula
  desc "Train machine learning models from Cloud Annotations"
  homepage "https://cloud.annotations.ai"
  url "https://github.com/cloud-annotations/training/archive/v1.3.2.tar.gz"
  sha256 "9f164636367af848de93459cf0e7919aa099c408e6ad91a58874db6bc9986bfb"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "81a34b1917063bd7833e975de95940b5adff4d7b98e08d18f3f53afa61d14f6e" => :big_sur
    sha256 "ea0076fb8a8b30ee1809d70d1864a8cb2475f06bfb330d42968dc1775cd34c21" => :arm64_big_sur
    sha256 "63f761d1b56137cdb4a2d94e5894c7a43ac28f8d9f7f36c2011da7ea21445c9e" => :catalina
    sha256 "6b8148ab93f63cc8342a2b77356c1154d875f710edceacaac4258d36d1ccb108" => :mojave
    sha256 "6dbca926050f4ca29a073d05591e818690d9a3d3cae0dffc7d658aab9afef02d" => :high_sierra
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
