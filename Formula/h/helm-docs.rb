class HelmDocs < Formula
  desc "Tool for automatically generating markdown documentation for helm charts"
  homepage "https://github.com/norwoodj/helm-docs"
  url "https://github.com/norwoodj/helm-docs/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "b1a0eba4120614f3ddc4d5cbe1133dcfc44ef746543c49a3e07168d2db55827d"
  license "GPL-3.0-or-later"

  # This repository originally used a date-based version format like `19.0110`
  # (from 2019-01-10) instead of the newer `v1.2.3` format. The regex below
  # avoids tags using the older version format, as they will be treated as
  # newer until version 20.x.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d{1,3})(?:\.\d)*)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eba1e91b5e61ec7040156632bef627ef0dd5625aad0753a887757ff03931f27c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49d016199c385757eff2bd246e57c130e955835ae6ec1d62be68149a014ac55f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faecf2dada756f4f7f1bda0d5f08386d258d51be956ba4ea6380a111024b19ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd685b2f668306f47d418fed933ee59261d1e0d3cfacfe8069e44e910feaaf8e"
    sha256 cellar: :any_skip_relocation, ventura:        "462c5093e116867eaea0284c644f7a04faf8fbcce65c5d1659085178fa03180d"
    sha256 cellar: :any_skip_relocation, monterey:       "736df8bcd7635cdcddcf78d4da9bbabd39b26ff43389d0fed0ef7be5d4f969c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "330cdedbb4afcb298253191709eb4e7b17d4615eca3382d78be7375afa9fd55e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/helm-docs"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/helm-docs --version")

    (testpath/"Chart.yaml").write <<~EOS
      apiVersion: v2
      name: test-app
      description: A test Helm chart
      version: 0.1.0
      type: application
    EOS

    (testpath/"values.yaml").write <<~EOS
      replicaCount: 1
      image: "nginx:1.19.10"
      service:
        type: ClusterIP
        port: 80
    EOS

    output = shell_output("#{bin}/helm-docs --chart-search-root . 2>&1")
    assert_match "Generating README Documentation for chart .", output
    assert_match "A test Helm chart", (testpath/"README.md").read
  end
end
