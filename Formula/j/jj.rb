class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "4f81eed321c3aeeb1e0528250f49b703710ebf91ba18238dd46f97b9a59aaa98"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dd178e23f06607faf1337086cb4c703f66b7fb9857c18ba71b37ed933bbfddb2"
    sha256 cellar: :any,                 arm64_ventura:  "34578e0f8af5af4aaaae2657e6a113e18604dedad9066aaba8f874b3116ad6c2"
    sha256 cellar: :any,                 arm64_monterey: "8cfea5e8752208333423115ccafade833a312bacf7a4a10481dbc330926d5055"
    sha256 cellar: :any,                 sonoma:         "712ae3378a96ea4592bc181f10bb6d3512f2855e628a2053c468609245c97bda"
    sha256 cellar: :any,                 ventura:        "f26cfa8e3f627f8bf7127d8a935e7ffff16e68e555c25314b3a9e0a09b395c8d"
    sha256 cellar: :any,                 monterey:       "56fa62cef28bf3cbf859934be4d0339547a211e746ba204692d6106c1127253a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae0525e2974df9365cbc702b119960d9c8458b0a93aa13c06deb54c98847b952"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin/"jj", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
