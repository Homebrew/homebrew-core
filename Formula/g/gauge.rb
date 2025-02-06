class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.13.tar.gz"
  sha256 "7aef626a523c5acd9c821d440bf099c0895a7e857a382ce54c12074e1a81e841"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70173747ea411ea7bd1161f433edfbe186c576f7ea4997c6a799c740b24713c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3c30e060cd789cb662f3ceaeee4de656a4ce25d8649217753283d3aa34722bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bab49f9df8660a3a803172445c12005f04c5e4883d6ddec3efd63571c5ad61a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8d7322e2adb98b56a4e8ad7543ecd328d3d34ea6d4c42f840d5f9c74c5ae42a"
    sha256 cellar: :any_skip_relocation, ventura:       "af22032a223aceb542d6e0ff0dab128434015ca18189555a001a46ccbc0db0e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22210d1f9b6b3a89d197d724fc49da976bba91e5abfe7fed532c10bd0382c3ec"
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
