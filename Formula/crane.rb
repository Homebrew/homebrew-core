class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/v0.12.0.tar.gz"
  sha256 "ca0064849191256ce019ef96d5a6cdbb86b7d0ff86d26510058d77e1002dd85c"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8af838c8ee2d7602c9e1dbe0f82848fd52400ce0d0fed005b501739ab9c69fdd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45b1d3b5d7cdcb1eef25473609e7e431e11f69da33878afdfbff8a38af77797e"
    sha256 cellar: :any_skip_relocation, monterey:       "a2ca616c7d3780ca5f0bb856f86f97907282655f4514d9667e9f3dd35f2193f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "128aef951141a580d9b202ef7ff5fed8e6c618bb870542e84dde015efb256a5b"
    sha256 cellar: :any_skip_relocation, catalina:       "70949a21cef7b62aea4afcdd708c99f21063d2c5408a7031aad5877f8c683cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cdc2b06471a66866ae7b88d6190fbe3a79241fda2f5a920ead194d099f7c1b4"
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
