class Komac < Formula
  desc "Community Manifest Creator for Windows Package Manager (WinGet)"
  homepage "https://github.com/russellbanks/Komac"
  url "https://github.com/russellbanks/Komac/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "b87a4cec1c2dc8a334812d240c668692ab463f81ca58dc210b95f599f148b183"
  license "GPL-3.0-or-later"
  head "https://github.com/russellbanks/Komac.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a2704b7b8549287b71ad9df0f62555e176fed67e9bf3d7e9d726c8caadb6d475"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "647d7f8a44675c86dbe5bfe71de100a2da78c7f10438d6784824856ced374394"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "17bb460e323fa5b893b98e505f372984063925ccd21fb2004a7a4dfb3465b101"
    sha256 cellar: :any,                 arm64_linux:       "b838ceab8feafb86b0721be77c2e699b25d9e80fc987533dafbaf1eee87ad229"
    sha256 cellar: :any,                 x86_64_linux:      "849b3df1e76027bb651b8005f72d90520fbe869923079145567efe7767d9765a"
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
