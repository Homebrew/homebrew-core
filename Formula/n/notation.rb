class Notation < Formula
  desc "CLI tool to sign and verify OCI artifacts and container images"
  homepage "https://notaryproject.dev/"
  url "https://github.com/notaryproject/notation/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "4b37f74646fd02ce05a4fd7eea48e463540133171c8811b486dff90da41bc07e"
  license "Apache-2.0"
  head "https://github.com/notaryproject/notation.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "169ccb885aefbadc0af07d8496520ee14b7e96a6946d9b1ab1580c99121ce055"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "169ccb885aefbadc0af07d8496520ee14b7e96a6946d9b1ab1580c99121ce055"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "169ccb885aefbadc0af07d8496520ee14b7e96a6946d9b1ab1580c99121ce055"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac41c269d2f3a8265ecc4afa4aa090e753a2642b752f3ba93c6305941001410c"
    sha256 cellar: :any_skip_relocation, ventura:       "ac41c269d2f3a8265ecc4afa4aa090e753a2642b752f3ba93c6305941001410c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea9b03114d7f26134611c39adc596139a7a8408a87f4021d819a1d7bee37f32b"
  end

  depends_on "go" => :build

  def install
    project = "github.com/notaryproject/notation"
    ldflags = %W[
      -s -w
      -X #{project}/internal/version.Version=v#{version}
      -X #{project}/internal/version.GitCommit=
      -X #{project}/internal/version.BuildMetadata=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/notation"

    generate_completions_from_executable(bin/"notation", "completion")
  end

  test do
    assert_match "v#{version}+Homebrew", shell_output("#{bin}/notation version")

    assert_match "Successfully added #{tap.user}.crt to named store #{tap.user} of type ca",
      shell_output("#{bin}/notation cert generate-test --default '#{tap.user}'").strip
  end
end
