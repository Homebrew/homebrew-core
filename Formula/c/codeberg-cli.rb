class CodebergCli < Formula
  desc "CLI for Codeberg"
  homepage "https://codeberg.org/Aviac/codeberg-cli"
  url "https://codeberg.org/Aviac/codeberg-cli/archive/v0.5.2.tar.gz"
  sha256 "017e37722553071932749ac107355f6b14e014f7fc3da116f0b6911b6f38e6f1"
  license "AGPL-3.0-or-later"
  head "https://codeberg.org/Aviac/codeberg-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4c2799ee32f6905320d3f8d0fa05e9b16dd4da36518a883040862c3c52bfcb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c49aa4995631476acaf39a167d7bbee20c478b324d99480258702aee94c43edc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0df433d701800643f87c370ecf42509a9d9a4934052cf1442cdc61d9a1f3d98"
    sha256 cellar: :any_skip_relocation, sonoma:        "83a4afb9e3bbd92ca27fc2dd3068ad2db8c19e082ac1ad356d2232e4aa6586ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9adb27f211c05afa4f5927c0e46a6ca30b9da1d11f4da203268be7cfeabb56b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "765650cfabac39afedb20678b4bcffc3ea7ab8c3e412277d98fa4a981c286829"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"berg", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/berg --version")

    assert_match "Successfully created berg config", shell_output("#{bin}/berg config generate")

    output = shell_output("#{bin}/berg repo info --owner-repo Aviac/codeberg-cli 2>&1", 1)
    assert_match "Couldn't find login data", output
  end
end
