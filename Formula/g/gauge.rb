class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.38.tar.gz"
  sha256 "376a1e3ee05fbfac48746284f4149a01929c05dc91af68b4156d2f2b51a2dbd8"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f6077050a12ed9462476832026f86048c7ba6c256866ffb5dcc15cd573c65003"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3ff4984cb808e8c9649cc6e012ac8ebc7d911f0bd7ddbaf2a157ae3851549674"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d1735d4a4de47c37de12fd4bd9a2f5247da8608084862b0dcc26849eb03dd0ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0edc4fa62329c02e7159e7255c4dbd459749a2370b9be0c95d4822336f9701f8"
    sha256 cellar: :any,                 x86_64_linux:      "061f67e6acb422933d59a46f5d5fa1fd4054f2b390eccb60b757ae898cedd07f"
  end

  depends_on "go" => :build

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
