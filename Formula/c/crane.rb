class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "2a03430b0c9a8cf3fdfde2608aed99f851e5c57dfed8246bcc637d03a7ab0048"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22242e2e76e5460be01311a7f2067d450400a39a30458c00c76cabb1ca5cade1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eed557840e34d21623b401e933a3dff8d6207ee1a43310934f9bcf01b32def2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d437097c50092cbee49ac6067f03e67534f05c0b0e5b9123cb4d82af23756366"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ba02331a0731dc4c301c6098cb4cad0faf8b74cf55d0e307e1a624e681ac947"
    sha256 cellar: :any_skip_relocation, ventura:        "e47b729eac5b42fb716c6e52fec094d722bfd18b1b3a4aa920b6b9bfa218ba47"
    sha256 cellar: :any_skip_relocation, monterey:       "242c76cecacd9a19fc8773fdea358769f56c980cb9d9bd4acf7e757f6f8628ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa18502819e2049be3fb1631dd42cbc0931da91a1c17c210abe4328fbc07e235"
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
