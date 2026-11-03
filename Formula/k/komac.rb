class Komac < Formula
  desc "Community Manifest Creator for Windows Package Manager (WinGet)"
  homepage "https://github.com/russellbanks/Komac"
  url "https://github.com/russellbanks/Komac/archive/refs/tags/v2.17.2.tar.gz"
  sha256 "389603a10151eceb5a424aea8339e39911111bcf385f90b140fea56275d47297"
  license "GPL-3.0-or-later"
  head "https://github.com/russellbanks/Komac.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "86dcf382b51d75c27fa966263eace30814c7cb9ef32afb6229f49b40b849308c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7df747656b1c5b2c20f51c982e30bf36dca7e0917a39f86284ac3ebbb044890d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "255c4d7fe632388ad7bbf115500289d223c882650e08d42ac0ec2a3ece96e867"
    sha256 cellar: :any,                 arm64_linux:       "9ecc00f3d52258ed9afe9cbbb08f3694f35fa547e84aae17c0c0a19ce5789146"
    sha256 cellar: :any,                 x86_64_linux:      "426ac339b23584c95760d8782fdd352be14c79221c5d4c64e19d9e14e1b96676"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
    depends_on "zlib-ng-compat"
  end

  resource "testdata", :test do
    url "https://github.com/russellbanks/Komac/releases/download/v2.13.0/komac-setup-2.13.0-x86_64-pc-windows-msvc.exe"
    sha256 "32c460e6d29903396f92f7b44dee1f9ac57f15d5c882d306e9af19fc7828842c"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"komac", "complete")
  end

  test do
    resource("testdata").stage(testpath)
    output = shell_output("#{bin}/komac analyse komac-setup-2.13.0-x86_64-pc-windows-msvc.exe")
    assert_match "DisplayVersion: 2.13.0", output
  end
end
