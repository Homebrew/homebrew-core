class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "18e0cc5600c06e940defce0a23ab4b29885bac265f94176603e5f8f926ed000e"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5910eed8ed991b959748d959a46ef497967043e6cd826aa36e26eae291dae622"
    sha256 cellar: :any,                 arm64_sonoma:  "04896aa56c97e9f43fb0719e9d33c9bf7fc9a8bfae697545570a0eb53e16d290"
    sha256 cellar: :any,                 arm64_ventura: "e4b4b42c6878d0dc0fa7ce1d254c51ed0993b1fd852087f0f1a03693af6ff26a"
    sha256 cellar: :any,                 sonoma:        "d6074df3e11a23b314b96e9078fe9568188c35e581992edaf454fc7fa8a9f72f"
    sha256 cellar: :any,                 ventura:       "dc5ff7e2c763fe8d00ebe0a452ff2288881aec133adbef7016b3c870e8574b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98608443f34e51980f2381544ba42e385081ab690866b53c78f9495a7e1150de"
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
