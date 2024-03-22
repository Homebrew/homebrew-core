class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/1.1.0.tar.gz"
  sha256 "9ee39d6777823d20de779ef12db4f2ac98dfd68539b6f9e58849760d38cfbf10"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f051d3d82edc5640212390addaf2086e1a44db4b8bdb8081d6861a963526e17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8b81d4004302c6384bad8aea18f44c6d0956f4cc7c654cff6203b5e2c6466da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "872bec6015b902b9f5764487c2a5ecf1bb9b4a3091cd85524bbf8577f999faf4"
    sha256 cellar: :any_skip_relocation, sonoma:         "074d8296a193fee3fcc107860cd3b213f06b2e3255d6a1d3f5abb2cbe563dca9"
    sha256 cellar: :any_skip_relocation, ventura:        "494cf807c5476b04e7b03a741b4aa8265efc43f81343f5b155533717011cea3b"
    sha256 cellar: :any_skip_relocation, monterey:       "575d81213cdcc95a4d11b955df1835479069f36af8b0a94bbc095b4f9bf1c4a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c8f007d6fb2ba70d40a702a9cb46d31c7b38ab0bff3704e67c19514769931f6"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
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
