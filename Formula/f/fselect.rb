class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/refs/tags/0.9.1.tar.gz"
  sha256 "6d635ed6e5b1b1be57ac6b047ce23cf9efd0cd488f615da54f70b5e34b466b31"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f216a296954150cf4476a1fe8b90ccba4f3f7f90a3b640f6d79f6a0eb6831632"
    sha256 cellar: :any,                 arm64_sequoia: "567234643873fa39e7c53465e39de5f6b5551a96c596f5f35ca7923ffabce28a"
    sha256 cellar: :any,                 arm64_sonoma:  "8ac5a831fc6a6cfafe49a2a5fce70eabcffec0fd713df5814fbdf14db22bb390"
    sha256 cellar: :any,                 sonoma:        "67dc77309da421955ceb2b6a7159d975fad12973f15c077c7008e79ebacb314c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbf5dd08b9c37212e09b01295fa636764badb1d390ca3104e4697034c86ce64e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b6d048f2156005b00c1edb36427d151a5e82b183735ce7639e84e8da97e7c55"
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
