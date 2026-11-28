class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://fselect.rocks"
  url "https://github.com/jhspetersson/fselect/archive/refs/tags/0.10.5.tar.gz"
  sha256 "6bce95ce28acbba074c36911d176c0a38b6799010653afa1abc35084bad642b0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    manifest_sha256 "d29acb40142da23078ab0d56c423cd58002d04bd8a52ac2e7188bd060f5c02a9"
    sha256 cellar: :any, arm64_golden_gate: "1bfad5d0640c8760c4e27d26cb5ae66adb409c247bf6c1c6a2368dda4296d54d"
    sha256 cellar: :any, arm64_tahoe:       "beddeaac5bc349000df136589a7686cb5b5a5bf887f6ae7dd5f6d597161407a9"
    sha256 cellar: :any, arm64_sequoia:     "17435c290a8102af499173983babf15aa9450058077fecf62ec82fdf2a720424"
    sha256 cellar: :any, arm64_linux:       "08eca9e8a00474985fb1b22cdc47065f6f35d0d4419207eaa423ccff5f2eface"
    sha256 cellar: :any, x86_64_linux:      "87b8b9ebc6b981757090a259a101dd7e090a0d57c03cf588594ef1f85352a0ff"
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
