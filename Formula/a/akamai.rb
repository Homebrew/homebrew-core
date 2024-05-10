class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "d22b26579256b372d62867083c5b625a51c5e6f067d0aa64536d0c5b1621c273"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0006a56f05371ba5c48fdcd3c53b9b947ab360f8470eb44ffc5639492bd8f6aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "447637ac6edd8902374fa6006190df9bb8b44d201e8dea9cd503d4e94ddf7479"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dc5fecd86a0407eda9d6d65ad2c123f9126020c086627baad75010739bb4f41"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6a4d4656fabc3fec8284f04712b28734a3eae7a660de4f50a2753dd4e0dce84"
    sha256 cellar: :any_skip_relocation, ventura:        "0a1ac8c5dfd577488d6dda38f8659d32a68e95a7a2e33d6bf18b0e521d360867"
    sha256 cellar: :any_skip_relocation, monterey:       "96ea867ee8aa8996e3b130306be065c6b2b72c0ceb7fb5628d740d0813740d8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be9c172ea34d7eea417f51393685858dfca2dc107f0b0093f126d0453c429c16"
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
