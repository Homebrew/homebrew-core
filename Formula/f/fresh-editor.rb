class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "3ab409970e18e692ed7a046bc0c27f4a68119858928e4b4b499e992dc7a0a118"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5d592d3e0b88825c0f785312d74c5eb31b4ca93ae98ef2e75bc40e76ae47c1c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "253f1879170129d3d834b0b891fa16d25ae863b98948d111944a589125742603"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b8e8d9d3dd4c304fa288c23f604bdacc5370a3e9eff442fb99362cf8c39860e7"
    sha256 cellar: :any,                 arm64_linux:       "ef4c15531cd1cf3eead5eff7acfac234f25739be1276516dc31d4a52dbc9f648"
    sha256 cellar: :any,                 x86_64_linux:      "3616643c0202110d61b9df4e2ff9b74f73a879b8949ff8baeb1f1d8b14a466da"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end
