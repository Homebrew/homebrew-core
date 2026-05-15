class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.99.0.tar.gz"
  sha256 "2235303c56707f260ebb94f7ad2ea3bf3520ce2d6a92ca8be4095825de2e0868"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9eba26e6dbe19a1f3d493640a72fb1e1b381f2dcb555accfa4d404cca4150e21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3ecdac02e17a7779f8743dd46281dcdec96a137855be7ed64fc278999faae35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cd19f31c0a3f2cabfb946a07bc1de1e4134478e761a79a6f3ccaee9c5a14d40"
    sha256 cellar: :any_skip_relocation, sonoma:        "19e4b22d034a553b32f6bb3dc9eb18e03e7637822c2e645a55ade2533ab64287"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "265531b58e6da0737eb4bc1f4857e4673dcfb8593eb947f4664c5926bdc87813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca9ba6c5f917236ed9a35792955b22e0fb8846a20a1646dbe8d2cefc47924b42"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    args = std_cargo_args
    args << "--features=system-alloc" if OS.mac?
    system "cargo", "install", *args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
