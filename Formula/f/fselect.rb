class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/refs/tags/0.9.2.tar.gz"
  sha256 "5263963ef5f02c74e968206221095722557a764ff92b7f343a92a37d718d87a6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5ad66c09932e4ed74ba415089f1c00066df73019686489f731ee711892e12739"
    sha256 cellar: :any,                 arm64_sequoia: "b263d2b0eeb1dbb4aa54b0774c6299f893a3b5766ca6cf54147d81b013a28022"
    sha256 cellar: :any,                 arm64_sonoma:  "480a4062148f0195d3a1b7ffb02f6b66ec52a0213a3358545285144ff38ef3c1"
    sha256 cellar: :any,                 sonoma:        "402dfebf0395bd8f7f198ba863d423c12d10a9bca6fcf0a4b5491eff4db46e32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc96e86e615efe87b7d69298f1b3cc0015ce9fe520c1b0a6e1dbc5fa19bf6ade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00aa3fe78cd421137a1afa88e26914968ca03526cb6db9da04845f266b772208"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2"

  uses_from_macos "bzip2"

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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
    ]
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"fselect", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
