class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.14.tar.gz"
  sha256 "ed86c8b8d244c5558ddb220a429c7375dc0e9caf1d9e3c37f624b72839ab70c7"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2277edd55858660e6d4b076dd5373eb88d1bf2e1bc931c355ddb26de61d48e72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07379e25eb787dae84c49f0623d876b74f590b59bcfe3539f83188cde7996006"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d616c34862552b141c397c682b413a016e2a4843d8e9d57b7d11e478db591c31"
    sha256 cellar: :any_skip_relocation, sonoma:        "85661467e4f18730d59dde1b57a1617ef35a2b3239a545ad5e331be750d1260b"
    sha256 cellar: :any_skip_relocation, ventura:       "7155df13b9fda49aece6e722333bda536b2e5a309a554db853749a17699e2aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1693ced066ca1a009255ba3dedf68d2d887fdf7481d0973a5682a0374a1d0e3"
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
    assert_path_exists testpath/".gauge/plugins"

    system(bin/"gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
