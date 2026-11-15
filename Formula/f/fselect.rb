class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://fselect.rocks"
  url "https://github.com/jhspetersson/fselect/archive/refs/tags/0.10.4.tar.gz"
  sha256 "cbcfba22855b92363fe39722559d649f803bf7acb9a433f54d92f290df006fec"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "75792175051c6e10e6d5afcd0313e0c8ee1d0227dd2996849e0d712c0c57dfc1"
    sha256 cellar: :any, arm64_tahoe:       "f835b4014e16ff231fa17f605ce24c1f2391eccb2dd7cea2b332d6a4d7d3ff4f"
    sha256 cellar: :any, arm64_sequoia:     "104da26de13a733c271f58c830ee332ca8b74a49d4d04c498d16f584387ffc98"
    sha256 cellar: :any, arm64_linux:       "fe69e10977a217793d7d9b3b4aed9cfb5ff91f48fa6fa0c85a89aa2d88aa5ff4"
    sha256 cellar: :any, x86_64_linux:      "ccdf7dbb04d1151b8f58e2655de8fc4def99770216871d30c1bc879d076cb47e"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2"

  uses_from_macos "bzip2"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp

    linked_libraries = [
      formula_opt_lib("libgit2")/shared_library("libgit2"),
    ]
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"fselect", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
