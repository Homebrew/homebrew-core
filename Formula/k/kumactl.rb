class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/2.4.1.tar.gz"
  sha256 "1b345fe1482905dd55173502c45b43cce54a22e40ff658b0c5ada50b611e5679"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a764386eb897de306e50d04d7cd9a9f5ad933eee582d2da0a33d1426dc30e64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5947d7a712d4f6604e429e2ca4c222e836f80c0bf780f168d0896a8ed86ebf8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5405aa5526da9f3a2fbed8ca4636ab51fa0942ae4e45bfcec325161ac23d5a13"
    sha256 cellar: :any_skip_relocation, ventura:        "90aeff41fc8e5485189bfa771ef17399af0ddbc46075c5f405bab88612dab458"
    sha256 cellar: :any_skip_relocation, monterey:       "f91f4ea6e5e84aa80e2e72069fc13d26a855123fbbf73eb2770e763d4388df2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "14593382b06239f555583a274538836cccb943fc128ca5772afe3bb214eed95e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a45a15136e2d000d33eaeeb0708fe02db6684ea8636e0ac96cfb5934f65eac6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")

    ENV["DESTDIR"] = buildpath
    ENV["FORMAT"] = "man"
    system "go", "run", "tools/docs/generate.go"
    man1.install Dir["kumactl/*.1"]
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
