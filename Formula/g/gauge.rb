class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.44.tar.gz"
  sha256 "1ead8ed9d5ace1a90a5200fc5797ae0dcade5a7c6025a746fee5b2bf80402092"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    manifest_sha256 "667765de741b391bd2bbca5c423774cc5e4c017dda2e63c146722adb7e57eccf"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1829163497208d75f0a2232f23a167b30457f48cea0951dd3c6f90b4be9fa0aa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "200cd1d213f0411c088a1b5c327eafd7ef6bf37df9ac80c96a2c4f07c9f0dcb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "515122783aea439308ac5c67efbea61f501bd90b4912791d38d63316c176c733"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a0fa825a0e68ca2b70f344ef727ebc7d88fee2bf8559c8aaa1d16158add22b00"
    sha256 cellar: :any,                 x86_64_linux:      "44aca34ad3d53fa3f386446ee7790ebd26a6ba0142aff19ddcab07ba60d78c72"
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
