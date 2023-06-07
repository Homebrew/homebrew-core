class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/v0.15.2.tar.gz"
  sha256 "9bebb3c42666bf082d7639cfe38295f2572f387b78bfaa1da8f8cd1e5bbb1060"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca0e5626f8f7299ae25515eb484fa3bc3b933dc59955607e8607d83e069a5376"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca0e5626f8f7299ae25515eb484fa3bc3b933dc59955607e8607d83e069a5376"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca0e5626f8f7299ae25515eb484fa3bc3b933dc59955607e8607d83e069a5376"
    sha256 cellar: :any_skip_relocation, ventura:        "b1d56c4a2311b2e65a3074be00dfce5184de2c9d2faa5985232fec9f5a539ac3"
    sha256 cellar: :any_skip_relocation, monterey:       "b1d56c4a2311b2e65a3074be00dfce5184de2c9d2faa5985232fec9f5a539ac3"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1d56c4a2311b2e65a3074be00dfce5184de2c9d2faa5985232fec9f5a539ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b81e001fac4b7e116dc9e91eb0808b36b2c861ff28488da4653059fe84b779d3"
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
