class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.37.1.tar.gz"
  sha256 "309194f35a6cabe8a91046641680862cbe1e1379f55c88c94337b541ce987969"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ea91a8bd51f8223c62e7e13ef7508d5bdf07d93af34fc02e229af5475a86599"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cd8b001b820b8b938d00167116c352a469a246c19c11252ca5f310fd0ef1b31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3def37ab85eb2bea054d74dc2e03d910cf93e88e1f21b93fcd99e48f7dffcb46"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b47528fbfe3bc3d912cd6d1350b4b50a39e4fe1de9aca9f2f9c56ef7b9340bc"
    sha256 cellar: :any,                 arm64_linux:   "d8c756d4fd5c558c29741cfe0e18f2e8b33d7623abd8b4a72c37c94021653476"
    sha256 cellar: :any,                 x86_64_linux:  "b6a78e25d1cf8a8cdec80188f633365d20d984a422a624ab8a50134b9c181ae3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    expected = %r{
      \e\[32m\s*0\s*B\e\[39m\ #{testpath}/empty.txt\n
      \e\[32m\s*2\s*B\e\[39m\ #{testpath}/file.txt\n
      \e\[32m\s*2\s*B\e\[39m\ total\n
    }x
    assert_match expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
