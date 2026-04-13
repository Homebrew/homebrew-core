class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/refs/tags/0.10.0.tar.gz"
  sha256 "e4b2612aef1076c5f045849c90757eee222c5b7b6c94e53909b931c1ba4d7f45"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec27fccbd7aeefbbbba28657b88384c294b417ae39e1e511435236f3b55f6f10"
    sha256 cellar: :any,                 arm64_sequoia: "134e23e5ba499e756e06c99754cda51df83e064d152f34c62950056f2de0d953"
    sha256 cellar: :any,                 arm64_sonoma:  "6ff02ae75a5aefcf30585964968df9ad844075b5b1deb416658cff55d3c807bb"
    sha256 cellar: :any,                 sonoma:        "a458cd014865b360f32e1ba9e2fd54dfeee7d4cb38e2d04221830d4fb3052cbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a35584aeaa958b7a98167662d09dcc61a308779dd2a42a08bed89913dde97a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "708797bd5ade2552555cd36e867f82207de10bfc43c783f827467bc17c2310c7"
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
