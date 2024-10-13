class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "ed49b1c01ee6086bb782a465a4437e2f1b66f43bcf39c231df2b261091ab114b"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ca729c593b4de7a68bf601cf4791f5f62283437e3e2c3ccbf1cc3b62c7492962"
    sha256 cellar: :any,                 arm64_sonoma:  "b8bf2630482af0134bc6d54e6dd542da452aad6767031bc19e02d139df789c37"
    sha256 cellar: :any,                 arm64_ventura: "3a3274b55153eee0a1afb592169814dac795f47aa18698c483a7acd211e9a123"
    sha256 cellar: :any,                 sonoma:        "48d5223024f8212ab0d8fdd7b0298a9689c7b45ad598d7ee298ba569ac83be98"
    sha256 cellar: :any,                 ventura:       "013f3f483794574d33c3f21d3f24149af3440585dc997cb7a6116cf46b87bf70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ce97b379ce2939ab3f4125e7b4ef6efeca7890d1f84b11c329ed8c6c584611c"
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
