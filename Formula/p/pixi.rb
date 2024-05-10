class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "4caa4b16687774c78652cb5facddf4d49bf7d0b2c482ebebe0401e7957ac5056"
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
    sha256 cellar: :any,                 arm64_sonoma:   "7b491db502eecc4c7dc4c3fc1ca8d6cabe1c14bfd8afcaf35241292201ff17a0"
    sha256 cellar: :any,                 arm64_ventura:  "f27872a57ca106050a110eb6b9338d51eaa66568ec62b50eee352699fc17cd06"
    sha256 cellar: :any,                 arm64_monterey: "845d50c26a92c3a589402f94213ec6667258a36afaa3ef6c5843f044e9d9581d"
    sha256 cellar: :any,                 sonoma:         "c009e68dbfeb7bfd3caed717975484e25723ee3d722af98f164905f46d6f3c1a"
    sha256 cellar: :any,                 ventura:        "ecc2e169c06747e3785c410d5921f5a5d79897aa88e3bcca83307eaf37dd2e12"
    sha256 cellar: :any,                 monterey:       "01f58378e5703697733ca24f647d8f23c76a3de0e8bf9717e7e805d30a949518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de1b68279d16134cac2944394f378a5193a3e09041f00a186eeac645c7b1c831"
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
