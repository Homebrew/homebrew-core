class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/refs/tags/v0.21.7.tar.gz"
  sha256 "4fa695c6a1f79793598d804cab380a3ba4f03539c0dbd4f0b9f38cdaf175ef3b"
  license "Apache-2.0"
  head "https://github.com/google/go-containerregistry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41df4ff442c4d4a0d59d7a56739b0cb05b372ec5b3c7639be3d02705fea0aa9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41df4ff442c4d4a0d59d7a56739b0cb05b372ec5b3c7639be3d02705fea0aa9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41df4ff442c4d4a0d59d7a56739b0cb05b372ec5b3c7639be3d02705fea0aa9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5323c7846b2e619bedc98d330f39467d8786f5d4a00fcaade717210c72b3fd3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d571743d486b443e33591a2952a0e8fc532aef43bf7151540efe3b026afe7eb"
    sha256 cellar: :any,                 x86_64_linux:  "97a90d0786bc4b5e59ebeb66ae723e7023c28a248a030320b5cc43b3168ce075"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/crane"

    generate_completions_from_executable(bin/"crane", shell_parameter_format: :cobra)
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
