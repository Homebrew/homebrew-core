class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v0.11.0",
      revision: "82e4ffd9f4967d692e16377e8b68f8ec971984ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c26ba95c01ee7809cedeca193823e807eb67a4842fd609498f760d02b9c0988e"
    sha256 cellar: :any_skip_relocation, big_sur:       "0c6ef34133a23883cb7dd319bb8c1e526caf4892c38a368b18e556e1e8318e33"
    sha256 cellar: :any_skip_relocation, catalina:      "9af32d22720e0d0504513c42bfb9c943bb42cc599d7ccfd24220e71da1b2b3aa"
    sha256 cellar: :any_skip_relocation, mojave:        "6f83eddd60a954b4bcfbbdd2720c646612b7b67e84280d0a5d7359ce549da8dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d66d18d247f43bb5d74ce90ee87e4bd84f5a93c0626086171c518c33de51c1b"
  end

  depends_on "go" => :build
  depends_on "helm" => :build

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
