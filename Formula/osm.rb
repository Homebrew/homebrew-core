class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v0.11.1",
      revision: "c01aefae509d59735d7908a32a359327ff3f2322"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c83f900219fa1b556c68a1eb7761f8d0bb0ad3dc6072977ad36eb6fadc7e4eec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "339a133e39c101135a735c6d6a42210fbe82be3fa022b602913bbef7d51c6cba"
    sha256 cellar: :any_skip_relocation, monterey:       "f486ee23471840560a9efb385661693e4215c3a7c4e05d7974e8b4f980e4e958"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c364faa784fdcc6459263149144ba6ce0c153e53afb5f6aa638a8c8508282de"
    sha256 cellar: :any_skip_relocation, catalina:       "691b86178c205485e2dcf9e904b09904418abe2371cbb9c930cfd56c0220ed37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8179406aa361fa495fc40f24d778cac43af2940b77abd135ea1d4b0edda7f6f"
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
