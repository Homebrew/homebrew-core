class HelmDocs < Formula
  desc "Tool for automatically generating markdown documentation for helm charts"
  homepage "https://github.com/norwoodj/helm-docs"
  url "https://github.com/norwoodj/helm-docs/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "628f1f9dac58eebba1f960863cdbf8045c9ec8fa740e32c7c15ac5edbf9963eb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad7301557295120b0621fe1d793b3ba614ba3e071136825f778aee2de3566c0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86ce0634b7771a373b13b3689e57f4773e36eff3cda2b75722f4bbe87c6fd6a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1885650c44ef1074f9d628c339f8576d972c221e8fe862b68ba0d7b2488b4bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c6fb59ce300d03cdc784a0cf93ed4818a4c094bb3a65e9a674721267a757183"
    sha256 cellar: :any_skip_relocation, ventura:        "7d1dd0aeec2a3ce54474511c54bc42575dfedf25f9c6df7d6b1501f75640235d"
    sha256 cellar: :any_skip_relocation, monterey:       "f75de895c5f0c027dda30dcf15f09ed21dc0fe794268588a1dffa223aae57049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a893bb6958caad01d3b609a621a901e1da2a6e9521f70f57104eaad64856bbf8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/helm-docs"
  end

  test do
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
