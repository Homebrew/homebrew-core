class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/refs/tags/0.9.0.tar.gz"
  sha256 "d0a9cdaafd8c8ceba1a2f02545171b0caa41ca575f9e30871bbd00f231ef44d2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d71673cedd85a6ecdecb8fbff60b7871b4c202109a8a026f58e1ee998962d452"
    sha256 cellar: :any,                 arm64_sequoia: "a2348c2091f6ebb03eb0c8687e5fc8610ae32a72ce8d141304e14da812b03169"
    sha256 cellar: :any,                 arm64_sonoma:  "e1f47525ead4f66e4e8e1946221976754e5bd47483ab5e07dfdc8d14a0dd1632"
    sha256 cellar: :any,                 arm64_ventura: "b28a71bce5306e0c5759fedccdc3ae1bd1238e59e8caf8b21d922999e3b0cce3"
    sha256 cellar: :any,                 sonoma:        "ab9ccd883aaf48d1189061f80d0c322e39d0ffcdbd653b388f84b7d55d6c4aca"
    sha256 cellar: :any,                 ventura:       "ec97c168c39981b5109c0e70a8a4bbd5abb7d6d1286927d8af645512f666a93d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ecce14c1d4be78c53a0287116afbe9ad15d4eb008fc8c0d58a2ef5590709d45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79ea06bd7e56fe0e0a659394de429bb37149802984937e985c99dcfa9b25376a"
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
