class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "f9657d51f971ef6f65a6dd8f2f7791d78afd7e1065989ceb552f1701f5434927"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6df8514c31f1cfffea1999be868bbe8169a8c39330c50b17ad5346a2c36eb137"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6df8514c31f1cfffea1999be868bbe8169a8c39330c50b17ad5346a2c36eb137"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6df8514c31f1cfffea1999be868bbe8169a8c39330c50b17ad5346a2c36eb137"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5b47ce468330445f4590a44eca2c1cc142beef16394d20305509ce198391adf"
    sha256 cellar: :any_skip_relocation, ventura:       "d5b47ce468330445f4590a44eca2c1cc142beef16394d20305509ce198391adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3973ace14a11112bc74e098fc036dfef38258ae86864ec42b622028d33581555"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", "-tags", "noautoupgrade nofirstrun", *std_go_args(ldflags: "-s -w"), "./cli"
  end

  test do
    assert_match "diagnostics", shell_output("#{bin}/akamai install diagnostics")
    system bin/"akamai", "uninstall", "diagnostics"
  end
end
