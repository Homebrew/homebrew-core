class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://github.com/tuna-f1sh/cyme/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "8f58f345f2e5d6e39841ef2bbd8c836faa2422dfb1fa2f3de7d37f860afa489c"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee3042ac5507e83a59fa42fd8c6301eda38bcdcce8d2908b8a9b72f1ca521dd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d4f87e350db67c32b23382f5ba68a33e18a7d862c550de7e12001498b57bb25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d32e7c1edd4f0cfdbd9210aa72fdcb0bdb22515bdacacf7defb2cd8d513b5465"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b34ce216d0231825e8cae6d609b9c470edb7340d2a2561c866ffb47cbab0b43"
    sha256 cellar: :any_skip_relocation, ventura:       "4fe8501c6c1896808f065c2ce4a5c0babe930a8a73673e25aaca50a1c8c9205c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8c4887a5549d2e508bfec3b992555e0b615a8532980825684d72fbf4c5bc49e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01253ed0a8225b096b6638f74cc272ab8a2c2f79b9a36a641ec3996a67984126"
  end

  depends_on "rust" => :build
  depends_on "libusb"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/cyme.1"
    bash_completion.install "doc/cyme.bash" => "cyme"
    zsh_completion.install "doc/_cyme"
    fish_completion.install "doc/cyme.fish"
  end

  test do
    # Test fails on headless CI
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = JSON.parse(shell_output("#{bin}/cyme --tree --json"))
    assert_predicate output["buses"], :present?
  end
end
