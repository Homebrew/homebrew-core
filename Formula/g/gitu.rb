class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "68a014a5b6b920ae1f82b473e7dddf9251755ada57df126c9a0a98725d1552bb"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1072f759f85641066d62ef806512de85fd29ed91c88243e2ecfce2efadf7edd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97d4c3fe4cdf3ee2f7727cc49d3863a98bc27460e5b8516f11c7a9172c206240"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ba8942b5f86ecefe7ad10b94dcfdd63581f8ff61b6d322f27147f2832655b0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cea667d08a258bdf4c91c222d1b715c78e82657ee154761c27b1ff010d833512"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcd5cd7599db34a1e37b6114738d2f7ccd803856700f654a7316466a4510fa43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cf7e9202afc3c5ce064b6db4b699bdbb49f9f31d7808630d99b7657d00b19a5"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output("#{bin}/gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository at '.'", output
    end
  end
end
