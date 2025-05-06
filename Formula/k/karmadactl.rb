class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "a5318a196437728b381802bc46237d9b7b6563a3259a19eba85c1e4de03ad425"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33bf7253e7453dc5742c1b7234c365b84e0a1a6e8c2869cb961b47aa21f68a3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e8c55cdc92e41c0a71b92eb6358b0eca97ec602bc5859245460e593e2225038"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26653dd1634b3306c039d057b49fc78e5228793008b34f68d53a594c1af935ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad80360ee1252a9b99de5403bde29d7d75c4559b17ae2d0c9707c1df5fb0204f"
    sha256 cellar: :any_skip_relocation, ventura:       "4cfade08a6b011814844ad08f6a5eaf8bc0a2beb18608f56015336e684c41ab9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea7b627988c96f7e68e046543c6c428ae023e332ba074dc150381dc08c4deaf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1017bbbf5e977c309b5767d8d037427878bd40fd179adf89d59a161f2f17fce"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/karmada-io/karmada/pkg/version.gitVersion=#{version}
      -X github.com/karmada-io/karmada/pkg/version.gitCommit=
      -X github.com/karmada-io/karmada/pkg/version.gitTreeState=clean
      -X github.com/karmada-io/karmada/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/karmadactl"

    generate_completions_from_executable(bin/"karmadactl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}/karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}/karmadactl version")
  end
end
