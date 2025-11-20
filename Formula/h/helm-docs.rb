class HelmDocs < Formula
  desc "Tool for automatically generating markdown documentation for helm charts"
  homepage "https://github.com/norwoodj/helm-docs"
  url "https://github.com/norwoodj/helm-docs/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "88d1b3401220b2032cd27974264d2dc0da8f9e7b67a8a929a0848505c4e4a0ae"
  license "GPL-3.0-or-later"
  head "https://github.com/norwoodj/helm-docs.git", branch: "master"

  # This repository originally used a date-based version format like `19.0110`
  # (from 2019-01-10) instead of the newer `v1.2.3` format. The regex below
  # avoids tags using the older version format, as they will be treated as
  # newer until version 20.x.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d{1,3})(?:\.\d)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6469d4abf186a72f762ed839038ccbcb5b0a9ae1ba3d2e184b448129dc29ca38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "91c39e8d994bccf86a38142464dad370c4f90efd76f0708a44ad179a8616c192"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83ae9a4b26f989027ccdb15b93bdf17cab1d501f1fe593f1c803399406b6be4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf56a0615e759c2723e4c01c05655e9c830f652cbaa0a6b97f72ede69a8d53a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4abcec8420c006dd7ecb2e120b1784a2ba037ca11f208461dd15daeba9d4ba80"
    sha256 cellar: :any_skip_relocation, sonoma:         "75d1650efc32f8b5539301435719ddd40d32ca7e619e497f0baa5ba374ee6b7f"
    sha256 cellar: :any_skip_relocation, ventura:        "1f25d968c9cd5ae22a5e2cc08f5ff15361fc990b9a3aa618dfb9c3180109b2f8"
    sha256 cellar: :any_skip_relocation, monterey:       "8967c19d3cea006bd846275c7be9e97e289dd7fff3763e763c50ec20c410ce73"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "426ed8f120588091d3e45a7f22f4b4ffb3b43f3cdf4c71f5b5b64aead9ad40ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78df0661852c388c2245a14aeeaf3442206a33ac08b1b7b74f233c72ec5d0cc5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/helm-docs"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/helm-docs --version")

    (testpath/"Chart.yaml").write <<~YAML
      apiVersion: v2
      name: test-app
      description: A test Helm chart
      version: 0.1.0
      type: application
    YAML

    (testpath/"values.yaml").write <<~YAML
      replicaCount: 1
      image: "nginx:1.19.10"
      service:
        type: ClusterIP
        port: 80
    YAML

    output = shell_output("#{bin}/helm-docs --chart-search-root . 2>&1")
    assert_match "Generating README Documentation for chart .", output
    assert_match "A test Helm chart", (testpath/"README.md").read
  end
end
