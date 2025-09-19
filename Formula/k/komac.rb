class Komac < Formula
  desc "Community Manifest Creator for Windows Package Manager (WinGet)"
  homepage "https://github.com/russellbanks/Komac"
  url "https://github.com/russellbanks/Komac/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "de416c0b4e0e7e81a5e078a534aff70f8864151c7f53ec5a94a027a7965f01e9"
  license "GPL-3.0-or-later"
  head "https://github.com/russellbanks/Komac.git", branch: "main"

  depends_on "rust" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "openssl@3"
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
