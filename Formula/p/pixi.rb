class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "d70dce587ccc40558d35ec355a2a6a7f74543c8358acfdaa1e217e38aaf56dc8"
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
    sha256 cellar: :any,                 arm64_sonoma:   "3f0ebf5c73c22696cdaf6ed467d9cbdd616e2f287a82286c769ca3e29c187184"
    sha256 cellar: :any,                 arm64_ventura:  "d853b8ab581e23b18bf282fffa03ba33c3e6b0ab918f22fc5d6e9025e40a2eb1"
    sha256 cellar: :any,                 arm64_monterey: "84348401f8c57c6ca5609bbad31446b716d5a49f9fd89d6c68554047d6c1bf9c"
    sha256 cellar: :any,                 sonoma:         "cd3f493bf5bf1bce711122672f9d4798ca1c9d0f1aad3a55ebb37aaa831a760c"
    sha256 cellar: :any,                 ventura:        "7e1f4228211905dfe1dd5f853f3ed8b0f82c7f12b511c2316978575c6a3c3782"
    sha256 cellar: :any,                 monterey:       "ee45100385a23fda05f921f44ee72435191ee8023958bfed7593f7cfc70b3a50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ef4886137c97231a3b11939a24fba7ed2b2843cbbd946b9ca1d85170c4d2452"
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
