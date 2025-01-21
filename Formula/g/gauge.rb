class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.11.tar.gz"
  sha256 "166ce88cac762c177c5ad25a6fcb442eea8558291792f4777101749f96b04baf"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "162ec5d81cb2c17c07eb55f5d4d8736e60be895b29459bdccc1992359d6a23e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2a06174722cea1040d41d1068b763e136e33ef394aff67faa2d546fa2ea6900"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8e13c938498808fe562cc4574849fd345a57ae852508332daa1c98cff3dbfba"
    sha256 cellar: :any_skip_relocation, sonoma:        "55daaabd8fd13ed472fa0afbf7e9f0c0b2e82e2153bee63a426e53e8869135b9"
    sha256 cellar: :any_skip_relocation, ventura:       "b43eed6b2ccbe0f6e3720ff037bdaebfa195bef9b46860eb25b33b2b1475fa4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01206600022f34f40c88675be310e9662b5a801da43ed166981f5b392b9f4104"
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
    assert_predicate testpath/".gauge/plugins", :exist?

    system(bin/"gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
