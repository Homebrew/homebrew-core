class Notation < Formula
  desc "CLI tool to sign and verify OCI artifacts and container images"
  homepage "https://notaryproject.dev/"
  url "https://github.com/notaryproject/notation/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "3db46bc335e8b6de2946a10cf907023806ba4ad02be6e176a9db65442d336033"
  license "Apache-2.0"
  head "https://github.com/notaryproject/notation.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97fc836806b2bb06100020bc657d93a17c50899c900a85a077007e4bbabd570f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2acc02df926ab022345928cec6c544dbb37427e603494272a2a5d28ce1949ce0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e116e617dff234806aad9fc24679763c61b399b10d64c94f850b57f43c0bd69a"
    sha256 cellar: :any_skip_relocation, sonoma:         "dba05ed99fcfd86d6b887e5335f890d5d1054ed6eea1b0c26c9235c40855a7de"
    sha256 cellar: :any_skip_relocation, ventura:        "51395e41f4bccec9e2602c4802f7fb71636d583cea69a20880b02f761c85539e"
    sha256 cellar: :any_skip_relocation, monterey:       "f1aac4641495ff5113c57488c6da218b745d7f108099ffed05b5c1833e747808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0659767d6531ded3f6d19f6f4c65757c4dd8a0be63b27f924589649f10a73e8"
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
