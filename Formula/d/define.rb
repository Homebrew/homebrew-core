class Define < Formula
  desc "Command-line dictionary (thesaurus) app, with access to multiple sources"
  homepage "https://github.com/Rican7/define"
  url "https://github.com/Rican7/define/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "b8f0a83bbf345330d1081634e3b865527d4924be8e771501283abf17c4304514"
  license "MIT"
  head "https://github.com/Rican7/define.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9193d4617c8c8958bd174457ac4d90b56e06bc6898d1dc22f0bd0d252e5ea497"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d98a366eb9aa54573e18a04522d60b6ff36a02d9693edf4aedd2e6023a4802cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d98a366eb9aa54573e18a04522d60b6ff36a02d9693edf4aedd2e6023a4802cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d98a366eb9aa54573e18a04522d60b6ff36a02d9693edf4aedd2e6023a4802cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a3f7a3a16a7595cffb41589a3cd0770ba91cb9b60001df8fd34c560906ef152"
    sha256 cellar: :any_skip_relocation, ventura:        "b8c0ec8a8a3b85cb98a43303d2239a9e4c733459891f340e50e9aa53b712a5ac"
    sha256 cellar: :any_skip_relocation, monterey:       "b8c0ec8a8a3b85cb98a43303d2239a9e4c733459891f340e50e9aa53b712a5ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8c0ec8a8a3b85cb98a43303d2239a9e4c733459891f340e50e9aa53b712a5ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "276816cda3256886daf23a8cdadb6861d22c3b697303b135dc86b8b018a45f0b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Rican7/define/internal/version.identifier=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match "Free Dictionary API", shell_output("#{bin}/define --list-sources")

    output = shell_output("#{bin}/define -s FreeDictionaryAPI homebrew")
    assert_match "A beer brewed by enthusiasts rather than commercially", output

    assert_match "define #{version}", shell_output("#{bin}/define --version")
  end
end
