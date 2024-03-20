class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "d3021bd676b6f5541b2d6296443349418cb17bd7bc1b2660501bb067e05fdae5"
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
    sha256 cellar: :any,                 arm64_sonoma:   "15641e5178f7d5f55c3ad20fc3f50b12809868807fac500c0a867e0abffb240c"
    sha256 cellar: :any,                 arm64_ventura:  "907b4ebf47caaf5c7a29d24c14da3cf3ecbea7a2257559a7eb9cd611b0848027"
    sha256 cellar: :any,                 arm64_monterey: "33033ecc093303f21a42879f94582a63c5329334e64f8fbc05de905e40949d1e"
    sha256 cellar: :any,                 sonoma:         "7c9b847415ffa00b94651e9b9711b6adbe796db1617caf000b550648d57fd87b"
    sha256 cellar: :any,                 ventura:        "93111234e493f09efdb7390bb29277258f6610f59ff1881aa290db5125cde84b"
    sha256 cellar: :any,                 monterey:       "30ddd40ed08667e23fb030b2023df119ac2f95ba4a2a300bd77bbf5cbdf48543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a524d750098d787a6a63552661dbf2bd8c605720bf4948582a1df4085281860b"
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
