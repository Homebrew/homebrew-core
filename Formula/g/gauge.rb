class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.30.tar.gz"
  sha256 "91e4ec94ac094baa298b873dd480fdfae19296c1ad99db9b829745b40fa14a58"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e968eb74da9d37b343d7cd143f370402fdfb41554b83e40ef0b4594eda7e1eae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c120952c0b793c28e329fd01ea2d0bdeea2b58c1e1a6ba455a90e686b8e0f6ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf4e9d40e494861ab1b0772ca63a81deec590ba736749b9675ae4d443032617c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4ea0c4b827386b44e868f512200c3a5955aa57fe247296976f2e6e1eb8dc485"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1823f5b77e9ddb41efeeda14d2451e09b1489422c4deb648182a3e6004800bdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86a5dda1f0375981c7ab026a15b3429dc7391c9b58832c4106d766d796b02d6e"
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
