class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v1.2.3",
      revision: "899fdb8e283aeca124c85c7a752e7b9534eea86e"
  license "Apache-2.0"
  head "https://github.com/openservicemesh/osm.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be9c4a1654d87af5b7fd4eeff862a4f7e2397d6f4dc6273c7c89b6212579d49e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea1b1b791f6c8039db5330d64f887bc03d7eea0a77f3f154d1cf1d0bd4cd656c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4e80e41e888d3f7e97ecdbeec24f315095b81d8f78db9b4f58c55f00349fdaa"
    sha256 cellar: :any_skip_relocation, ventura:        "53f6f7ff024c9a7e77e49cc55ae7303ecd4af76129872d907037fadcddde1799"
    sha256 cellar: :any_skip_relocation, monterey:       "f8dbd01637b4cb0371c81c99fcb87f588871ac55575a474b40ac12f24615982e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8ed806a17e503c1bcbceed00fa1af69c363e31c7bff33a18b7f01968ec1aa8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eee3a9b49d178f1613c73705f562dc58fc61c8ec8058e4e210fed94a5719468e"
  end

  depends_on "go" => :build
  depends_on "helm" => :build

  def install
    ENV["VERSION"] = "v"+version unless build.head?
    ENV["BUILD_DATE"] = time.strftime("%Y-%m-%d-%H:%M")
    system "make", "build-osm"
    bin.install "bin/osm"

    generate_completions_from_executable(bin/"osm", "completion")
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
    assert_match "Version:\"v#{version}\"", shell_output("#{bin}/osm version 2>&1", 1)
  end
end
