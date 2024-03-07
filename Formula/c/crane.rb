class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "c07dca10f60339d03e3a690daae8512741e9a2bc23c0bcb3104b9892b43179ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b93a103556c5dbf34167b5ec6e132111999bd393789aeebcd6d5766360a30021"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fd2c280ada5e481bc62b005fb88c8a14ed3452e552afecad5e265cb2afba985"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "389dc7b13b83db38339428e1e47edafde5101bfabc8f4dec67a93f895a628efb"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb261d589cfc7a95f6561c8f7e2b62cef6f40dcbd47c40bf19e9e69025aecc9f"
    sha256 cellar: :any_skip_relocation, ventura:        "03ee73bb1969a47b0be6c9642b856013215213d20f1dd4b8c4bf7cda76180625"
    sha256 cellar: :any_skip_relocation, monterey:       "25351548ec587df08d8d22972d919c6efde528e15542a5a86359a12ca2f2fb13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "520ca869a07272954e8573f0a622361a6fbfe1dce367956ea1d1cfc440ec0dad"
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
