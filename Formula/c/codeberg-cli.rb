class CodebergCli < Formula
  desc "CLI for Codeberg"
  homepage "https://codeberg.org/Aviac/codeberg-cli"
  url "https://codeberg.org/Aviac/codeberg-cli/archive/v0.5.5.tar.gz"
  sha256 "d824fa482f122cb6b7189ec5ab75bc2c672a623de65cca8884bbbac54e062af2"
  license "AGPL-3.0-or-later"
  head "https://codeberg.org/Aviac/codeberg-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "a1cbaf6e9a5b077d36c9a784ff4ae275fef953cfc0f05316a1a5c767788fedff"
    sha256 cellar: :any, arm64_sequoia: "7db56fb4b4a99261b7e404233545e9313e4ecb44f47f5f18775206d972f43325"
    sha256 cellar: :any, arm64_sonoma:  "b6659965cec7a554d216d175d167cf0ed4fd39fc1b22eadbc0513fd057c8bc10"
    sha256 cellar: :any, sonoma:        "cde33866ca9c736d043408bc17a4c079bf2d952b53e2a599559fbc89f25b7fe1"
    sha256 cellar: :any, arm64_linux:   "26945cdea3daba8ada3eb5c584ee78de52633f70d04c73a3b45e0a87d1a29c4d"
    sha256 cellar: :any, x86_64_linux:  "97d2407fc68ecbe43e3613c4bbbd8fcda78f9424b08ccdeb29dfc0dd97d180d5"
  end

  deprecate! date: "2026-05-13", because: :repo_archived, replacement_formula: "forgejo-cli"
  disable! date: "2027-05-13", because: :repo_archived, replacement_formula: "forgejo-cli"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
