class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.43.tar.gz"
  sha256 "24b69e9e543f95eb2a54a10f15b6a0d67b4b8206a70662198ff3cc25bf1eae88"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "caa541c2b0b359a5cb891ae834bf4aefe84dc5a22fd093ef0748cb344649b2b2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e04c195cbe5ce35e56fb3982484d1e1c756363a547e5215a982421e592015bf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db8a0327c27b2167ee119b53724c1dc480ee6b6dceb6fda24ec87b7dfd4b1483"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ff22c75f6ccb0ef5ab20c301cefca2621e15c0672c64f650ea19ab12bbdefaa4"
    sha256 cellar: :any,                 x86_64_linux:      "8db95f3f43e09223db2eccadf5fe737a11e99c43f6425b47c1f7753cf3069903"
  end

  depends_on "go" => :build

  # Test installs a gauge plugin
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix

    generate_completions_from_executable(bin/"gauge", shell_parameter_format: :cobra)
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
