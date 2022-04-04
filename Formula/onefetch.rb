class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.12.0.tar.gz"
  sha256 "f57b16dfa2bb95dd1fb805257a1761baa20d69eb9ce7c311d369609894c53897"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bde32546297e98275c6fbacf28dbc3ad18e3f3a90deac0bc1fdf092d8383c13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5474070a72fd6aab344dae1da7397824ed7a033601d7ddeb5cc95d07ad5fd3e8"
    sha256 cellar: :any_skip_relocation, monterey:       "bbaaa0e844d51459467094c46d7a80e99ba91f1d98bc14a5d2ee7477a34ef57e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ea304b224a67b84b3b69f1b03686cd57b9653c79e436e2e3e3e2d2e29016d67"
    sha256 cellar: :any_skip_relocation, catalina:       "e51937d3e851a076c7900ae0402e5a9a988fd8af0bdca63038cc52eb8b35f54c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6fba076a2d577312cc34fb2eabaca97e4767cf822f6e7698578f624f1f4e1d8"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "echo \"puts 'Hello, world'\" > main.rb && git add main.rb && git commit -m \"First commit\""
    assert_match("Ruby (100.0 %)", shell_output("#{bin}/onefetch").chomp)
  end
end
