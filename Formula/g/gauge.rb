class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.31.tar.gz"
  sha256 "efccc27163a36328a3d067bad8a33d4094058708e2555311cb36db740de3b266"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7cb76c59301bb5186d6bd5980a8a54634cbfb56b70f6223a7da187d3b3eb1ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f9ee74def98628f3454ee91505d0e2a227a2dd67ff816cd2cb788cfb7c35f2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7427ba3eca8bd4767bc35b291e22ebf0f844d63303eb422495550e233dea2f16"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1a2f9c02ba84a2052efe594b0cf3f481315d61b95ac7afc517c2c3152608ab6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bffb2b9d468ed5e90b47af09dcfa09305c52fdae720e88e737ec8d4911ff97e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8017e45d89dd3971f11d8e2bc8d83a11c089facf14a9b703e028594cd1d28ed"
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
