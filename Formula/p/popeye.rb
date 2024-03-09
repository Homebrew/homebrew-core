class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "c2889b02bd7ed8b75f953f27bf8adc1bd881b2e9cd88f671c8a1cd8ee6ded508"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37cf974e60ce90bcf64ca9b7b83fd9562893608d866dc10b37eb245a7a859d19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdbfe1f9c6e54bdcd92a923b08689b1b28165bc5c6e5435a94b450e572f915ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c261f62209f2cd502bce06c7cee093f9513e262d59953956c5ef079ee4791422"
    sha256 cellar: :any_skip_relocation, sonoma:         "12a978dbf6facedc77ee5a73c3db70060ace1736449b51aeaec1e45f80149caa"
    sha256 cellar: :any_skip_relocation, ventura:        "e0df67d14466568583b6ff5b3abec993781c59431fb39e931c7ed6ee15a53f8a"
    sha256 cellar: :any_skip_relocation, monterey:       "84a77f63918b99d75d48f235120b40263ccdc69e75421888f642e087544478e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38eae50bd3ddecde171efc917bae0e531c762ba3b4b532b617cc0be2a3ade5f4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/popeye/cmd.version=#{version}
      -X github.com/derailed/popeye/cmd.commit=#{tap.user}
      -X github.com/derailed/popeye/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"popeye", "completion")
  end

  test do
    output = shell_output("#{bin}/popeye --save --out html --output-file report.html 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/popeye version")
  end
end
