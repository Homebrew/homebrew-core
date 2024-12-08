class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "c0e92ec25b7500deec2379a95ab655c6c92021cf4ccb29511fee2377e37b35d6"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b52227f624002fec2ea390892b5422ebf013368c08af701c0feb125b0eff3e81"
    sha256 cellar: :any,                 arm64_sonoma:  "f80d5012e2e05ece55292bc7265c516fc3e7e9224bfe2c274186051921376ffc"
    sha256 cellar: :any,                 arm64_ventura: "5fdd4798b48df95fcb69fd1a2fd9cc0e5667c3a10ff079801d3671dcc2ea03f0"
    sha256 cellar: :any,                 sonoma:        "a44672bc799564eaf420c5f085423d0b0e84466cf72afdd2c1e9b77babbee10a"
    sha256 cellar: :any,                 ventura:       "bfead7f4fa6ca72320bc49fe2bcf3bb139a251bf7ea305302e6d3ee077a26eba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fa4160a7b8b5038362b0606ccb7a878cb9ebf5bc89b0853f6e04c77d6868211"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable("env", "COMPLETE=bash", bin/"jj",
      shells: [:bash], shell_parameter_format: :none)
    generate_completions_from_executable("env", "COMPLETE=fish", bin/"jj",
      shells: [:fish], shell_parameter_format: :none)
    generate_completions_from_executable("env", "COMPLETE=zsh", bin/"jj",
      shells: [:zsh], shell_parameter_format: :none)

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
