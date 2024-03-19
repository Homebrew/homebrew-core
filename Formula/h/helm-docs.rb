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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1f3b63fcffa9ca11f54986fb0b08ecbf4824fd3bc0be4157eb67a1c14497cf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bd816db49061e0b4a4b76dc04752208be37a219a687965a3a83d54fdab5b3de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce36c56f5a617e57fb993b1499abcbd624cdcc3c30992327a2a2661f64b17c0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ea34eab9e1c486220b897b7a9989aa53ba6abbe2caf22c1742ec693ed591501"
    sha256 cellar: :any_skip_relocation, ventura:        "f489eb808a80fd3ec0f85dcf2e579f47c103f381b7eb82b38866a447fb6a90a9"
    sha256 cellar: :any_skip_relocation, monterey:       "afb3041b1cf9dbc2057364b72a41d4428faafd291a13419059e36632e2828cf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d59a049890f84003b2cdb866d77ba6c1e84242daf7c10e65af28c90bc87c7bab"
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
