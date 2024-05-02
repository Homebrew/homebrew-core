class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "e0f141356239fe765dd5ec64c329c38d80aeaf838afd657f161cd71ff0988c0e"
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
    sha256 cellar: :any,                 arm64_sonoma:   "6c14505b813c45b9fe076d1768dfb197c63167b8832c1d586048f0db460f7a3e"
    sha256 cellar: :any,                 arm64_ventura:  "fea483af4959be55f685d2d58f7c3ff4a5efa798048f79f91b87294588898beb"
    sha256 cellar: :any,                 arm64_monterey: "abb930e47bb8a8c235f823d952038949cd2de8900f5f227289e29d815b95c994"
    sha256 cellar: :any,                 sonoma:         "326e7bfaf975fae4f6fc2ad0b809d94a30b5a7d4bf8b8261d01ef36951203948"
    sha256 cellar: :any,                 ventura:        "5acef7ca565ae0a432624770d5654cb4864845de8d278e575669020cd9f16908"
    sha256 cellar: :any,                 monterey:       "7462357a9ae26b3a24d4bb53b6dad71e3829a8bc09a4c3bc40c356687d24002b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd4a20cc1ba3633003215b480ea69075812c1e499f5d2d312dcdf6fa8839fb31"
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
