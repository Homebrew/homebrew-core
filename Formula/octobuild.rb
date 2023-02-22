class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/0.5.0.tar.gz"
  sha256 "625fd5bf3cc4ad7f7d93940ab3a12ee0426c3e5388f2a2d8845db03ee2615a01"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
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
