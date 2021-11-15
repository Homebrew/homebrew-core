class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/v1.4.2.tar.gz"
  sha256 "6b87277a5d31894f3bc5baa80af1d808e39fce30ec4a27041799c8ec5f052de9"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "671b8e9c25a5374b2895762d9e33b4c5c97afe1ea627771696192c9696f61c0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7751da96693a8499fca9b396e9e94b6f6c3498bd98ffd4e780fee3679ed20d03"
    sha256 cellar: :any_skip_relocation, monterey:       "2f324653647adb1fd0cefe00aad9148639021415e62864bbc9f9fd2cf295a075"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c27af9593357ee89ebbceb3bb481f8df4b857240000bbd7b1fd7be0a053bc5a"
    sha256 cellar: :any_skip_relocation, catalina:       "2400e3c25e61f7d3f3317ce20c4cccf3f798fe01aa2ff44baf01d98c5ccce1a8"
    sha256 cellar: :any_skip_relocation, mojave:         "de5dc9501f7101c1b17106e48fe0ce13b3ebbf9766c2c68581f92df4ba8cde8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2e508df60d4aa0c43a9bf1fde6068d6e50049e6775f6df3639400c587357c36"
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
