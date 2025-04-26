class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://github.com/tuna-f1sh/cyme/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "14bf4adfbc3a50b69d3685dcac87f18c7ace22719e8a797eb96fb12ab8b06e55"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "397cd720384b750eb3c851ab5ef06e8af9fa365d00f1259682e8643294f0050b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dc4588f72cc9b202bf234e58f28bd7e781a7c68c1e78bfaa982558fce83461c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6838308abcc0abf69fdf951328025c8a9f03592b820adac02221ab85d0332126"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c1256db1a740008d9765d6b89faa2a7cc82fc5d6b9b76fb726ad47fd01269fc"
    sha256 cellar: :any_skip_relocation, ventura:       "6829fbe5eb6bddabf59b9dd29e05aec20e9b1a30cedbcbcd7260f5737466b108"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "954e08126a3505e4cfa787ee0be6ffa75f964cbb0c7db09ca551fd4895b890cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f41513927e9cf8ba7a3b148f4150de83776b12f66d7e90e8eedd8a41782eb31"
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
