class Komac < Formula
  desc "Community Manifest Creator for Windows Package Manager (WinGet)"
  homepage "https://github.com/russellbanks/Komac"
  url "https://github.com/russellbanks/Komac/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "00e2dbc44bbc25bdfa9c8b425b641736b6677bc8b388d288e2c9bc37531d4ddd"
  license "GPL-3.0-or-later"
  head "https://github.com/russellbanks/Komac.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84dbdb915c8a60ef427b244d1358abd5f04f9e02cdb8f60bb65a69ea1cddbeea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62412ca1ce2fccf139a4b85b308cad62c58dbb58b3c8649dfa854674e07b43c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c2694b4f7a1acd52f057efe6c5f541e550c21b1d884481880cdc3b1075ff5a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c39adf41541f063b64a935841fc190024cad997ee9165f3e14272525babfdf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85d86fdc309d27b48f7703d45fb771390978be13647158e1e70443151d98cb2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e12421bdc9dfffc4875c41b7a118673c67cec6bb4437225731d8f77288a9fe68"
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
