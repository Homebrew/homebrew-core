class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "bdb512c0235f8133eb21919095161e11860530636c2085eeb6a9d5d8556188f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c53e2cd857018bc8dc72f217137edf845e1779f3b1199ede95d1d4e945880b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe1db62e6cb896f8898acb70c2514cfbf65482779ad429eb79cabc0da91195ee"
    sha256 cellar: :any_skip_relocation, monterey:       "de0b83b7306dc48c28a61465be4b912cd70d2b73d80845e536247c2ee441b768"
    sha256 cellar: :any_skip_relocation, big_sur:        "8964422d8a850b5a7407888f279bce8bb2b9816b3328e22709c8a069b9f5fe0e"
    sha256 cellar: :any_skip_relocation, catalina:       "253bbe5c284a157bdf3b30719cd3124812d3ca5533e45e95c54f72a790540ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca3565b7bed47b00f8d763837f9388e960baf04f71c1d1be6a39489bc526689b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=#{version}")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: #{version}", output

    output = shell_output("#{bin}/epinio settings update-ca 2>&1")
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end
