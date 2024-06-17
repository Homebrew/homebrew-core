class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "110f41283fb91ba6d34f6eaaa33b373a2ca026a88222293bfb711c5464059dca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06f2cbfd977b32dff7d119cd8974f408591be6099f1efcc99584984666f7d9b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b4e8f2e3eb155c55a4803a622108113eba1f584b823cf2bed40d9e418f93259"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d12cb9afccae6818a7dce3f62e569a610a02e330710da584978b2de2da8cff7"
    sha256 cellar: :any_skip_relocation, sonoma:         "025eea031e8a93ef0d159a5776557f92b6a9999371d46bfdb38b06ce25624671"
    sha256 cellar: :any_skip_relocation, ventura:        "5d47a8f63b6e5919b7b853206dff74e64a0dfd8e1896fec76c8bfbe27b4ff6cf"
    sha256 cellar: :any_skip_relocation, monterey:       "c0a0b9fa62b6b01f7b8502708e14c7a8fc8e6e2d039875284571b74950b40bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96722b5047d54de9f369f820916916f475dc6a52fb24840e1a0654ae956817c5"
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
