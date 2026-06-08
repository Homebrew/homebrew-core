class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/refs/tags/v0.21.6.tar.gz"
  sha256 "7ce44d0da35a4c4fd1db24d50fde075bec38d744a016b91b2d5c116e59d156a5"
  license "Apache-2.0"
  head "https://github.com/google/go-containerregistry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32695c20f1c07b36937021d07f23e27772b79890e3b19c6be2625a9fa9a2ca22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32695c20f1c07b36937021d07f23e27772b79890e3b19c6be2625a9fa9a2ca22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32695c20f1c07b36937021d07f23e27772b79890e3b19c6be2625a9fa9a2ca22"
    sha256 cellar: :any_skip_relocation, sonoma:        "f818306197fc432c7954fec8bfbea3e5f27f1b5c3e77e5d98f647da845585441"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d337b14394fa03c0fbd5a7b8e1767464ebec628214f7411682909c1f942c74e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64b2f0eaad991cd71b5c90e80fc16b1a9dce55218c326aa23fcd526eb6b9524d"
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
