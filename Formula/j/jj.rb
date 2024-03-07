class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "e39f80edaa01da29e86782424d031c38324eabff10c44704781c80fd60c9fb0e"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c0493d70ed1e11483aaf89e6315544f60d2f9b7dc1b70b3f961c761375cf0bf1"
    sha256 cellar: :any,                 arm64_ventura:  "78b650ca6fb88f4ac839fe8f0056c4fbefbd4f21c1afd991b5edb8360f062d5b"
    sha256 cellar: :any,                 arm64_monterey: "02c776bfbf80e68d64be98471e4d588783c2e59258069b7761b0f58a8feef925"
    sha256 cellar: :any,                 sonoma:         "f2d02f01be8e0ceff9316f9be23c9297b3db7de135801bee43c01b73fef09dfa"
    sha256 cellar: :any,                 ventura:        "52d5d5c36d17b1142b0bd760c3a6b3045ec7bb295f424c8e73b3d657d8301f57"
    sha256 cellar: :any,                 monterey:       "e5bbb2ea3a39075def140d159c52adc9ba1bca45c58332d9eb91c2c3ceef8b0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cf7e08d1dce031dc81d3971a1f3f728311456de23a93aa726c021fb7950b651"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", "--bin", "jj", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"jj", "util", "completion", shell_parameter_format: :flag)
    (man1/"jj.1").write Utils.safe_popen_read(bin/"jj", "util", "mangen")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin/"jj", "init", "--git"
    assert_predicate testpath/".jj", :exist?

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin/"jj", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
