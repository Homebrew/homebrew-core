class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "3024d5bb85ce882c71fce449c20fcc66c47d5d6547c9a79873769cea82baa25b"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/pixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4f8407a2b4d84b19f5331af6c4c345cff865a7595762595c8895e44aa1c34679"
    sha256 cellar: :any,                 arm64_ventura:  "b8bfc2f5cc4ac6c45eeba909bc2f6a4edc4d7298e94368d5c1bffd5dfd279ae0"
    sha256 cellar: :any,                 arm64_monterey: "8cf3e363acefe8484b9bc0f97b12137c1450304f64716d112443ac33cea806e0"
    sha256 cellar: :any,                 sonoma:         "1ff77d8a7ffa2421220eee9e66d172c98a12de9ff9afba47d52609070cba64df"
    sha256 cellar: :any,                 ventura:        "3a3ca7be2e541e7f83a7d6fae430b9c73c0c05a869766c77c4d89fdff0e45b3a"
    sha256 cellar: :any,                 monterey:       "7dc5db63485ea7cc73a2453ea33251b9bb168fa69c76bd253245d74b1e7d15db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22b10f50b16c555d556305edca164acf4afc9e2979998fa3d62b4495685323d0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "openssl@3"

  uses_from_macos "bzip2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip

    system bin/"pixi", "init"
    assert_path_exists testpath/"pixi.toml"

    linked_libraries = [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]
    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"pixi", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
