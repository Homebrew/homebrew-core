class Notation < Formula
  desc "CLI tool to sign and verify OCI artifacts and container images"
  homepage "https://notaryproject.dev/"
  url "https://github.com/notaryproject/notation/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "ed3f59b96470de1d53da64283a0b81000e3d3193f1b8c80f764834d8124a697c"
  license "Apache-2.0"
  head "https://github.com/notaryproject/notation.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93c93fda8136ff9f88209e2ccc520e4557edad0d5006f6c70d2e7da4b26f27bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93c93fda8136ff9f88209e2ccc520e4557edad0d5006f6c70d2e7da4b26f27bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93c93fda8136ff9f88209e2ccc520e4557edad0d5006f6c70d2e7da4b26f27bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bc38bf0a9afe139774c69c796856069c5474bd22b687b5d82bf48300babe7d9"
    sha256 cellar: :any_skip_relocation, ventura:       "5bc38bf0a9afe139774c69c796856069c5474bd22b687b5d82bf48300babe7d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "051c86bc0519f990ade4cdc6c8b60ee5110bffffc19dac693552e80c9f419884"
  end

  depends_on "go" => :build

  def install
    project = "github.com/notaryproject/notation"
    ldflags = %W[
      -s -w
      -X #{project}/internal/version.Version=v#{version}
      -X #{project}/internal/version.GitCommit=
      -X #{project}/internal/version.BuildMetadata=Homebrew
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
