class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/v0.7.0.tar.gz"
  sha256 "f2e4d7f2e57811a706e669e75c5d43377d5967ab1846a83304e91b9f35ffce06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "070c3eadae0efd8f53c3dc94ee3c1336e7c71fc615d0c552f64ac4ea4244852c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ffb746d6ef0185abf32697be0e680db644c3cfee8456de1eb553f2848eee284"
    sha256 cellar: :any_skip_relocation, monterey:       "f0ff1e2b1bdeea863d78afbbd74c564a64dd9284c34c03817f009a22009f4df4"
    sha256 cellar: :any_skip_relocation, big_sur:        "03ce66cf350edc2f394a795c8f764e313ab5931a77a74dc4798dae93af78ad34"
    sha256 cellar: :any_skip_relocation, catalina:       "6040b53b95433bece0ee14c8415ea527d7f20ddc1ec4bb4d368c2762091eb8e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03239ce727dc36b5d558991fc5e8cdfe3e8c0e6deca6ff25bdd9c28feab002af"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/crane"
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
