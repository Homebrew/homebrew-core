class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.40.tar.gz"
  sha256 "5c3e2262c96164599a04382d1fecd9462d69efd03cfba6863d67b624973429da"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05342a58f9b807f73ecb5e559cc5b5fa7e00e06cd69ad5cf8443631c77d6d0bf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "36473c686dc9985b2e5dd4858bacff6738dbf3ca01cc3dcb5fbc93e6561db5f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36b27cd518553cd664a10bca9f9152d89db64121a898f4561e7008381f731ef9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "631dc9b7256f0dd63d3508f64d3cddf0eef68932896c59ba54e6bf099c2333b6"
    sha256 cellar: :any,                 x86_64_linux:      "84f1a537f6882828355ed000881907cd967930b4585433f82badaeff5874fbb1"
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
