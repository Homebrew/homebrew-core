class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.24.2.tar.gz"
  sha256 "3eeace1adb473bfcbed0f9b73d958594d8674e477a44e182e96d9e23d36bc404"
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
    sha256 cellar: :any,                 arm64_sonoma:   "2bb531fb0952c5c30177530c8786b83b58988f2b09cf50e5c14f880e68d3737d"
    sha256 cellar: :any,                 arm64_ventura:  "4b34f40479c9fde9b67b0aa95225a4be853d5de418b6778c2a214e4eb2f096e0"
    sha256 cellar: :any,                 arm64_monterey: "bf647a4ecee07d0d8e4960c5cb45821c829de27fd5f61c00fd2ba535852a039a"
    sha256 cellar: :any,                 sonoma:         "dc50c4f7dbede1eeb8685ad699c929808e1c1c51fb74df8fa4d58f92aefef7ee"
    sha256 cellar: :any,                 ventura:        "c889fa684fc8169e7b89b550e65d719911f3019955cbd53b02277aee14e762d3"
    sha256 cellar: :any,                 monterey:       "f5bae41e274de85fe8543ef41e9a5d218224a2b3886daf214a9f7ce02b6cb407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e66a02e707b71970e7c805511431159413fc50029557b5990c271c159fde10d1"
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
