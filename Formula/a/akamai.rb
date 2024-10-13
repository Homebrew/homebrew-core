class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "dede02e8809659f752415e55e5d1a42134d1c6f131dd2cd7b02ed91532848b61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7d6c7c34ba1d380099f2b82b2ea591c7678baf1d623cd60260f6f4c6ed2e0808"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9e56901b3d5999efa5d5c95faaf1bc1a0378f15c5293abb0997437c35bff2eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9e56901b3d5999efa5d5c95faaf1bc1a0378f15c5293abb0997437c35bff2eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9e56901b3d5999efa5d5c95faaf1bc1a0378f15c5293abb0997437c35bff2eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "8edbeeb8344a4b66bb50adf30c224a1ff98070abac44247f48f068ba889099f7"
    sha256 cellar: :any_skip_relocation, ventura:        "8edbeeb8344a4b66bb50adf30c224a1ff98070abac44247f48f068ba889099f7"
    sha256 cellar: :any_skip_relocation, monterey:       "8edbeeb8344a4b66bb50adf30c224a1ff98070abac44247f48f068ba889099f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e790d3e8a5067d51753040cbb809520e6e3371fafe8f59456d5ddf8d1385d51"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", "-tags", "noautoupgrade nofirstrun", *std_go_args, "cli/main.go"
  end

  test do
    assert_match "diagnostics", shell_output("#{bin}/akamai install diagnostics")
    system bin/"akamai", "uninstall", "diagnostics"
  end
end
