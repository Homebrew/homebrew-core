class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.18.tar.gz"
  sha256 "103d4a567e9e9bbd2cfc9569603f6069dc3c8787d76eeb7ae93787aeea7db68f"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "642b5b0bc143826cbd923c54356e06832124b95aef8f865d46fe9131c4781e45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9b7b4a0b5629a4ffd5c86f301e7f2589442924b0788ac3f4ca1b4ee69fdc2ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77b7b849fb1960ffa259912282aae83223edc022da7e348e12602b3c8bf73f9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "60e9f9762bbbc6c64246f7581b11bd410cb240c38f146380cdf54fd281d05921"
    sha256 cellar: :any_skip_relocation, ventura:       "f95fc4467de072fb53e558b793ad40ff72490611beb1f364189e5a867bd48880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa8613b526748a8b7e90efdb021c46f7103eacd146538e65a520ecb795df02e3"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
  end

  test do
    (testpath/"manifest.json").write <<~JSON
      {
        "Plugins": [
          "html-report"
        ]
      }
    JSON

    system(bin/"gauge", "install")
    assert_path_exists testpath/".gauge/plugins"

    system(bin/"gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
