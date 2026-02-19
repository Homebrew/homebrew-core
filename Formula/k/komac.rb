class Komac < Formula
  desc "Community Manifest Creator for Windows Package Manager (WinGet)"
  homepage "https://github.com/russellbanks/Komac"
  url "https://github.com/russellbanks/Komac/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "c22ef89c9018a35b10de14c953616721864a86f2a6c4c83f4ceb95785cb8635d"
  license "GPL-3.0-or-later"
  head "https://github.com/russellbanks/Komac.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "214e38f5d5c2c934cb4730294f7d94919f0129dd136069e21d2f833edb8fedea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b90d1fe43e4c27a434199c3d30fbdefb99773ac8f8d2bfe38014ac093909d97e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "288abbf1428b34fc43147f81c6cd62ea9998b944c2153d4a4e8ff39d1e8f00b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3f6d5c6588ac64eb53e290deec9c99ac0e2975cf6f67d959273422a2c08dc96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aea31ec2083ae5d327a15256d64c94dd377ecd896079b83b2fd9685b8b198bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae362118eb60fb3c89ade19d437675f27690e4fd60515d3bda34f6bf20d1a6c5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"komac", "complete")
  end

  test do
    resource "testdata" do
      url "https://github.com/russellbanks/Komac/releases/download/v2.13.0/komac-setup-2.13.0-x86_64-pc-windows-msvc.exe"
      sha256 "32c460e6d29903396f92f7b44dee1f9ac57f15d5c882d306e9af19fc7828842c"
    end

    resource("testdata").stage do
      assert_match "DisplayVersion: 2.13.0",
shell_output("#{bin}/komac analyse komac-setup-2.13.0-x86_64-pc-windows-msvc.exe")
    end
  end
end
