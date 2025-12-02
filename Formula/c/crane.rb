class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/refs/tags/v0.20.7.tar.gz"
  sha256 "623a87ec77206bae301a9af64b42ba05e602b1608d0ee3574749b348ab4dd7ac"
  license "Apache-2.0"
  head "https://github.com/google/go-containerregistry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "531595877872f345621dab9ab17731613e6e40a7a2cb01fa1b47c6ec41911f6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "531595877872f345621dab9ab17731613e6e40a7a2cb01fa1b47c6ec41911f6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "531595877872f345621dab9ab17731613e6e40a7a2cb01fa1b47c6ec41911f6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "de6392fa513bd651a664a3ae74a69819c9ed3d3472c041884ee8c7674e41b85e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f96d8271a08b34ff99790f9ced31dc51953f8586db819ae620d5a4c481c3a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "561680df7f182b8bf73710b65b85af983bc3c58aaec2a4ad852e8690ab06b370"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/crane"

    generate_completions_from_executable(bin/"crane", "completion")
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
