class HelmDocs < Formula
  desc "Tool for automatically generating markdown documentation for helm charts"
  homepage "https://github.com/norwoodj/helm-docs"
  url "https://github.com/norwoodj/helm-docs/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "218ac8b089ab3966853bdbecd43e165ede3932865f0fb2f15c4197eb969c6540"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62b308b6476acd46baedd295954629f738926b9866256fad0ffc64594589f10a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ab6a34cc3ba68caffaa8b60d55a7a5c630813ce38bab1d7a29b130005309d61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80f292f11e404a3eaa6e88e6645245da57e15681c1043d616483d5c0a18c64a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a4525ec8765f6b6320888f03b3564a5d1dbe696edd5659d38ac46fbc1626092"
    sha256 cellar: :any_skip_relocation, ventura:        "bf8df16b5bc31fbd6b40c292128f882a410fe3412050e1377d47030319610145"
    sha256 cellar: :any_skip_relocation, monterey:       "a5a3811c3caadf8159387ba28879b787a44c15823731ad6c4e4e8806173eb98c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85557223c6ac1dd254acf44bfe8454445897922e213ae44727ebc5348ec8f8b2"
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
