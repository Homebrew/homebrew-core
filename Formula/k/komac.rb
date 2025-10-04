class Komac < Formula
  desc "Community Manifest Creator for Windows Package Manager (WinGet)"
  homepage "https://github.com/russellbanks/Komac"
  url "https://github.com/russellbanks/Komac/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "de416c0b4e0e7e81a5e078a534aff70f8864151c7f53ec5a94a027a7965f01e9"
  license "GPL-3.0-or-later"
  head "https://github.com/russellbanks/Komac.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a74787073a0936171542b60c3a99955eac8303892a1d081b47462cc8eb2434c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "726323246c1a7ef794898113078323a0a62911f19a2f1bbc8e6ef1c3a7d2f7d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59f4d6783d2b96ad26d7a377f87e6a712a7ed8442f61d1d27daf5c3a100d5391"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ee73eb9019608ef7c5666546db312651aec21d4b611fa0ffe60dcad7f0fae79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "240759489a1d204e5d7364277417331721f1b8b52bed7cef804fe84d6b92d553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8559a3b61ba29529b37ee44fa5889cd5fb5ad7fbb4bfc921f8b4c9d29f18fe1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

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
