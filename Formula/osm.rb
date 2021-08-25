class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v0.9.2",
      revision: "7df9badece2f251515a2bc5e5ac79438b0c58812"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a2a20685a28595e5fad3da5c7d0bad9382ccde3fb6c6f79c5db704e3a61ebec4"
    sha256 cellar: :any_skip_relocation, big_sur:       "16055308152785cfc55766e4c9442ca3bec6a7d73417a7566e33d2d09f0445f9"
    sha256 cellar: :any_skip_relocation, catalina:      "45b455fde94c3d7656523b64edac88a6f4bfa3906f4b5550b6cfde04161d6c46"
    sha256 cellar: :any_skip_relocation, mojave:        "90c80ee43dc71ce031dd6934eaec95d9e30e1b539ba7f35460232ea8dd31e465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a594bd0be57ed6e939c37d6b878a2f8ad0f24626b1a929360857e495f8d2c753"
  end

  depends_on "go" => :build

  def install
    ENV["VERSION"] = "v"+version
    ENV["BUILD_DATE"] = time.strftime("%Y-%m-%d-%H:%M")
    system "make", "build-osm"
    bin.install "bin/osm"
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
    assert_match "Version: v#{version};", shell_output("#{bin}/osm version 2>&1")
  end
end
