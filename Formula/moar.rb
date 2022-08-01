class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "6345b1afd6c32adb296956c10553b93f23aab0571bd149345d415dbaaa53ea28"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbd27ce5e3c91b3c04fc59fafba5624ac280125e8a7ea2bb11ef6ef0eb3f6a09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbd27ce5e3c91b3c04fc59fafba5624ac280125e8a7ea2bb11ef6ef0eb3f6a09"
    sha256 cellar: :any_skip_relocation, monterey:       "71af06fc112fc03fbad119a49ca9fd86183012690105a3dc7821f236b0933c1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "71af06fc112fc03fbad119a49ca9fd86183012690105a3dc7821f236b0933c1e"
    sha256 cellar: :any_skip_relocation, catalina:       "71af06fc112fc03fbad119a49ca9fd86183012690105a3dc7821f236b0933c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebb74868dcf40eb8b83cc91b29924082c435d8600ddb3ecf71cd3527fcf8c06a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
