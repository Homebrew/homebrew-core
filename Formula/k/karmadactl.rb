class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "4310a81928cd1c64b7e9ebd34806727927d04e6535034ff62c27f2beaddb9430"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "365321ab6442d3f852126ad6eedbdcaf1e256853b6c29e8cb0f2012f11ef2f82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99f24e724b4ceb88ff48b798458575bce6d67b201e306d7a04016796855f99d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36dc1e9379171998f193090c8676ef25e313224af4316e726125948ff704f1c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4477313b435aaebf2adb7250757c8c7574b2af206ece79693d2020a15260b70b"
    sha256 cellar: :any_skip_relocation, ventura:       "3fb963fe2712d420756210acafad8792008e3de36b9247830b9412aa40b2a2b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91212d9bfdf8e83ae6f3f693c80326c234ec3ae99c475fcb4ee9eaeefc669c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19d5682c0a677a97bf3edb8b650711d227a15279a43d86480367cf904c84e218"
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
