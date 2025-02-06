class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/1.7.0.tar.gz"
  sha256 "c89f162f7b7d3e197c3da6e736745f1105570c2fb5b30a23cf22edd46c6876bb"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72142b4636466ec9e91523c1d99cc77e1b12f6a6916b43af264edf23309ca901"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b682aded6c48f1f3be1c60963918e79e3f0f8b36c4c785ff8829c115040bbba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b25fb3405ea525260de88a3ede5c46150514679ad971b657a72265904ecc897"
    sha256 cellar: :any_skip_relocation, sonoma:        "c797c17138ab1dd3cdaf9393f8499fdc771e98629fa44d3eac9ad718e27bd041"
    sha256 cellar: :any_skip_relocation, ventura:       "ce5f745b54b4e9251c48909e3f7350cd28b42970a619859fa2f02a808d08005b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eef7f382ab1c2b2478be87ff67de4f4e57156f7241a7689a67f7105801b13f18"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
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
