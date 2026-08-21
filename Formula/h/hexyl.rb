class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "72fa17397ad187eec6b295d02c7caabbb209a6e0d5706187b8a599bd5df8615e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/hexyl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a380040d842d6ced8dc8015f3d9b25d45c5b60f594f4480609d011ef22bd58d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6056e76bd579cd03b0658c2afc15be46381cf6329a4fd25b6ee43fc0bfb6be8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64c933b2a5bf71487abbfe7d056960955a4eaf30d28040d5745b661e5cddf8d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ddae4d3fad1bc47f842293c728ee099aa4b6e1693a93ccc34b34776ecad6a35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ea9567b1f011c966988dec4e0bbfa23e7685733a9b5b938c65302bc19603e91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2728e436ddc3e43a3bd757a05c7e375681b8e1e057eb606f151bc9925a7b0ed"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "pandoc", "-s", "-f", "markdown", "-t", "man",
                     "doc/hexyl.1.md", "-o", "hexyl.1"
    man1.install "hexyl.1"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/hexyl -n 100 #{pdf}")
    assert_match "00000000", output
  end
end
