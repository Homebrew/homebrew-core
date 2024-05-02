class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "855c78912fc8ae22ec96de926605ac2bc4bbdb48c572a7a7fe386e8fb9aa0bb1"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c319117bb88fa56b16ebe9ef7aee7f0ccbf87a044275820316bdb1b62a8b689c"
    sha256 cellar: :any,                 arm64_ventura:  "4d554523f4db6db3b003296011424674b8a87479ce037fa52b1562b0ecb8ff5c"
    sha256 cellar: :any,                 arm64_monterey: "16567378734dd88606f5e1abafac30cae53a8ed2a890af90e71c9dde0b6b7255"
    sha256 cellar: :any,                 sonoma:         "1df642569f3d7a970f07e751438dbcac8eda868321a9fde0245ab03847fc9346"
    sha256 cellar: :any,                 ventura:        "a97c12fb77acdb1bcdb8e1785912b14d39b63f03da8df8d6a90e3119d0ddd816"
    sha256 cellar: :any,                 monterey:       "501bd1885a2290e249ec01b04f707237bdabac08882ddf6c95c7bef0f56d4e1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "279e6d183429da1aea136155b8bc791e8d709edf08a3aaf5189dd0876f9300ce"
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
