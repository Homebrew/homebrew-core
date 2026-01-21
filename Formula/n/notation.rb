class Notation < Formula
  desc "CLI tool to sign and verify OCI artifacts and container images"
  homepage "https://notaryproject.dev/"
  url "https://github.com/notaryproject/notation/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "f7239ca8155329b57f80e5fb01bf189441b3ade572ad9d6fc4582c1475b8e840"
  license "Apache-2.0"
  head "https://github.com/notaryproject/notation.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0c86c17163bb958756fcdc3acceb03dc2305e4d773be66bcf955d6279de3b94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0c86c17163bb958756fcdc3acceb03dc2305e4d773be66bcf955d6279de3b94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0c86c17163bb958756fcdc3acceb03dc2305e4d773be66bcf955d6279de3b94"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb0ad7df50b917a1cdb158856c230cc57f248959c070787c8f1255c5289ef5d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df34a4436243a4732c50c3f9792a308d2ca8c9f3fafc8c26110e98582838aae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab20e895a13f4caaa72e467a085dc3aee1da0c4445d567a75511a87df911af47"
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

    generate_completions_from_executable(bin/"notation", shell_parameter_format: :cobra)
  end

  test do
    assert_match "v#{version}+Homebrew", shell_output("#{bin}/notation version")

    assert_match "Successfully added #{tap.user}.crt to named store #{tap.user} of type ca",
      shell_output("#{bin}/notation cert generate-test --default '#{tap.user}'").strip
  end
end
