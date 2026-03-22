class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.27.tar.gz"
  sha256 "4920c6b33dafb8a9e093b6a6d34e9d50f1aa5f2c792c7232fa1368f84fa027dc"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d688c8f63d73462605f150e0766bc335ad9c41e1d4b016ae7b009a214b570ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf31efcac9fb753c48c2426111a397b80f97f26a523c8b7b217c21f715c2b1e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee5dc5eaf55c4d6da530090454a0e2f4b8fdc181c84fb77ef9e1159a9d220bf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a98fa721784b378a1a510ce953844a75b07a0537bfbb1ed9f8bf7f1697207b5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dfe6d666fa8cde557a3a25588ab3e36743b8da1482ccaa024d37abd4725cc3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abcc3888081efe83edb6dfb2decd690961b3e75df04adcc05d7d1d7394ebebc4"
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
