class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.43.tar.gz"
  sha256 "24b69e9e543f95eb2a54a10f15b6a0d67b4b8206a70662198ff3cc25bf1eae88"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e69871d50c19c63e4f8e143c52e7effa834bb409609be34817ef2cc50b8fb9e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "34e28ec51ad561741dbfdaeea1c7cff242ebf62a3aaa3036503e8fd8ea6ce2d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1155bb71fa3e112ccc2e61811d0914024f1cd9c792d872aef76377f057bdf6fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "550600039f123b98afb38c15bb541265d30cf35039ab61d7000e33bc1b055460"
    sha256 cellar: :any,                 x86_64_linux:      "39481d15568ae8631f9222732cfcdcfbae74a4ff2d538806cb4d20ab1faed00e"
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
