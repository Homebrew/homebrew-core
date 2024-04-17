class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "94b745a46a40c52e087b422db4cb7f1c22711c4e7b8211e8e10fbc9d90a810d5"
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
    sha256 cellar: :any,                 arm64_sonoma:   "3ff8e953c61ceb31b95649b8051ec8b2a13e60699c84b2e3cfcd10517d882210"
    sha256 cellar: :any,                 arm64_ventura:  "e4800c7a3b79669202b615c6ed073e854f4965db6d810523002fd9479fa47df3"
    sha256 cellar: :any,                 arm64_monterey: "771012fe14f691197f7836ccf52baeb5891072eb439c9a260e9d8572c0560adc"
    sha256 cellar: :any,                 sonoma:         "3524f75492d3449b30357a7354bff45f84b5f1fd0dbf5f7c37e389dca7083596"
    sha256 cellar: :any,                 ventura:        "f3d119d64e5f2e16b4e610ef2de44f346c768cef232f80e0e673f78e81726ef8"
    sha256 cellar: :any,                 monterey:       "75a788446d2cfc1f45765ad0b58c967db155e52bd604ccb38b44ace46350b2a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91f224293ee0f747e0cbec32d91467ea64466133a40c569383d11518201e55cb"
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
