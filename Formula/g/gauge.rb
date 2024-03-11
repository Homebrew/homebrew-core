class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "75eafd7b6105ba0fcfc38789268c994b926bbfe77cf9f16c4b1d7b846f59ec8a"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2d19d3b0b08e4020336f90f819ee034e6e41fd6ec75e1c4d103f662ac094427"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "661f2ad14f46253beed272a45c80e305b6fa18b88b07f3773b664b3b188980f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb0ca26e03ee921e4ef3ca849dfbd33449c169fba51985b3fcc1cbd8c675edd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "34d6718b63945b133c0eee69a8cb561b7cd0eac37dfa5d5b3a16db89794b3fdd"
    sha256 cellar: :any_skip_relocation, ventura:        "88c335624471fe007d4dcebcd6415cb15a94df8e61d7d42fa22eeddf4a331837"
    sha256 cellar: :any_skip_relocation, monterey:       "b76fbf78528077432c4101f6a78df2e6abfa9a6f56f896343e41f626796893ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93ab3376e98110f04831b21e778c5199ffe45d04fbe549e78e8447cdeedf027c"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
  end

  test do
    (testpath/"manifest.json").write <<~EOS
      {
        "Plugins": [
          "html-report"
        ]
      }
    EOS

    system("#{bin}/gauge", "install")
    assert_predicate testpath/".gauge/plugins", :exist?

    system("#{bin}/gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
