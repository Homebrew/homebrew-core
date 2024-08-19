class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "b2c898ea224fe45df81c241bf1f0bc8e74c0988b8f549e894b15a38f2f4d6665"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "db83cee7c158bc3442257f79e234dd165397cff7c6e7ac2cd377845f75552c56"
    sha256 cellar: :any,                 arm64_ventura:  "669eb3e49a95e2f46e258894f0fbe6d288e65bebfdb8f9ef9077d7c09dd42f97"
    sha256 cellar: :any,                 arm64_monterey: "429c44c58615786220a924f75dec3779e3e49390a12313f810b321076430b46d"
    sha256 cellar: :any,                 sonoma:         "4ddd8983252c9fa6a36b31253e422185f93a4d115c85b176841416974812926f"
    sha256 cellar: :any,                 ventura:        "e84e0d615df7ba7edee793a6fa54f7829df870c3f109549c95a9b0f65f560b23"
    sha256 cellar: :any,                 monterey:       "7c2c14a1ff7107e768a48a7dd4c29125784174b634d1e5c822e68dbe91132b47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f9b313f81fdaeec7d1a296e12e0183b9c5b7e47b220281033f66ee08d3546e5"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.7"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cli")

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
      Formula["libgit2@1.7"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin/"jj", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
