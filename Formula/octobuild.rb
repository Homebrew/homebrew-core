class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/0.5.3.tar.gz"
  sha256 "fc7b437edde217a43883c56228f95d945b4e7b5bfafb521c0061b20ef21671cc"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8c1df9821ad6b9ad15104588edcf8131a65f611483d8ea7ee6c1c57d1579688"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2db57430758b5f74811c0bd339be61ef7c986fdf48522fdb2ad03fae5bc22f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bcacee8089646f4c40e5028d7fe2b4e735c55fa7247061e2f751c45f97284bd9"
    sha256 cellar: :any_skip_relocation, ventura:        "b108f4739d1761a34352279211bb4a6d889b2210332a8766eb35cf4f006dade8"
    sha256 cellar: :any_skip_relocation, monterey:       "a54b87feec80bab92494d7fed4914e1c2a262effcd8dcf16d18bbd43ab1ce572"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e080cd167ca4c3273e3b98d97eadc487af0373ccffe96333d699e00afc64b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e9530eaaf4da96b310dcd3e91a043707b563fd60d475e2e633a0140e040dba7"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin/"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end
