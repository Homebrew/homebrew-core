class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v1.2.0",
      revision: "893ff8722a65bbfc2afa6e416bdca88c58393d00"
  license "Apache-2.0"
  head "https://github.com/openservicemesh/osm.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdfa00de2ae2be071b8b3d9beb29063d0396af1d691fc7975ecd9283e7a6aa0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ef887e729b75b18870ec76ed4516a4797f3fb6189813ede231aeb51c718c5bd"
    sha256 cellar: :any_skip_relocation, monterey:       "e389cea9a24c1ec3b52841a0c1da3f6278dd37d81c762b6de41f1d375c01f3f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "419a3ad16c8584e1f4ff52077d53415950e57caac79a0a28c2cadbcea0e6ac37"
    sha256 cellar: :any_skip_relocation, catalina:       "2353a8d8089735ec9b9e7ddacfd6d8a58e865c9aadd78d9eca4a03822ffc8737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa11722e9db23fc1553377280d885725c1a1f65383504677972242031b2a1f6e"
  end

  depends_on "go" => :build
  depends_on "helm" => :build

  def install
    ENV["VERSION"] = "v"+version unless build.head?
    ENV["BUILD_DATE"] = time.strftime("%Y-%m-%d-%H:%M")
    system "make", "build-osm"
    bin.install "bin/osm"
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
    assert_match "Version:\"v#{version}\"", shell_output("#{bin}/osm version 2>&1", 1)
  end
end
