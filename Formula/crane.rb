class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/v0.12.0.tar.gz"
  sha256 "ca0064849191256ce019ef96d5a6cdbb86b7d0ff86d26510058d77e1002dd85c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f17497e00beac372362618fc35306f0aca1af943752cbc47264baddf277d051b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d19a884874ca9751e75229080b2002d25d8079a8af77f0f19a95b44c344ef680"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa9269824363a4156fdb085a632763290a164515b89b8144f7d7b688f87bc6b4"
    sha256 cellar: :any_skip_relocation, monterey:       "5c8a25c682fe8bd21f9e0c6cdca1a72b2a7be40e19a62ee66487f0a8791c5860"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2d6bc0abbe7aac2aa9b59b6da6b7bd28e9285f0ba8c9a74255b23b721395042"
    sha256 cellar: :any_skip_relocation, catalina:       "62d72865384630a536487dc823138c6137b3fe5da271409073930b07d3c92f7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d729e498376d233d2fe765335e830176d8bae8121aa3e9121e43fea66252f763"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/crane"

    generate_completions_from_executable(bin/"crane", "completion")
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
