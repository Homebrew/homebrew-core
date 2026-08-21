class Komac < Formula
  desc "Community Manifest Creator for Windows Package Manager (WinGet)"
  homepage "https://github.com/russellbanks/Komac"
  url "https://github.com/russellbanks/Komac/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "a88eb12956091e2e5bd9b15184a4efc953c037346fe66f81d2553c08b9e81da4"
  license "GPL-3.0-or-later"
  head "https://github.com/russellbanks/Komac.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73b35bb2d85e740a8601845dfa23958bd12d6d6d0b85831665e11e2ae8b63b9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35e910178255d87137e43f4f7d71396982e9b8c930b40a777ec2f382b66caf23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92eb2c50aad8a8a812245f5118f71ed5a8e8f28b04ead558f60439ca755f2575"
    sha256 cellar: :any_skip_relocation, sonoma:        "70d1b06a7ecbda682281841b977f16c1b9d81d838f4280c4734374a902dc0825"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "295c4d298fedffa4ff7f6becf30607c6b5651ee5b892309e9e13f033144653f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "362ef26a8e39f78324a3020a0bf4e446c52a60c70d22e7eb6b1191f10e83d618"
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
