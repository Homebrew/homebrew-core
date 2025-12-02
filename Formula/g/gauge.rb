class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.21.tar.gz"
  sha256 "d6c5af38c7d98b34b51c783da496d37c54d7fc2dac2b7c28f73a8b21aa1c0df9"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af4725c7e5d047f8861f840d64c6119c77fb2ca804dca642a7fc157e04a65cee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "507c2563b1b71f709e29b88ef4fedf0cacf77dbac47bbbd60486b902f376b44d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5ea4ead2a3574c763938ec8a2420840665fd53bd3a28b293da77c44cb60c15c"
    sha256 cellar: :any_skip_relocation, sonoma:        "248f6456f321d8d81306f757584329db60567c65eb7557c88f67558f6ba3e3b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eeee2ed9cea33370a0bffd778b742785b4bdfb10440a46ae4af94ac0ae3e6635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3454faf2db069086e3177b7a33f4859e19a176772183f6b8764b76262a876f64"
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
