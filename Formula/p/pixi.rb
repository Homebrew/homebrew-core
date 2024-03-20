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
    sha256 cellar: :any,                 arm64_sonoma:   "066e5930f9232940c552d80d180840a4d1ca22e24c80bba59f54428072cb73d0"
    sha256 cellar: :any,                 arm64_ventura:  "8ea2d8ec1591d26bf6456939f48de01507036e0d43b35c8b70a71039a106a277"
    sha256 cellar: :any,                 arm64_monterey: "29d2c0081732bee3580978f5918136539d9a0da1d3a7ccb0d18962abd7ecf564"
    sha256 cellar: :any,                 sonoma:         "28b6f853b99c78b84e97d8c6e2c9a21832447ed30706ebf114792e6a7cea74ee"
    sha256 cellar: :any,                 ventura:        "f129a59cad90d48cf10fd215dc3874c3cfe06f9d53d22e73a73d8ff7e2119ba0"
    sha256 cellar: :any,                 monterey:       "66308d9a6a0f7c26cb9bea46c226075955d74112c49e5efb45880241015a68dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0bc92e820c633d82be4a065c35a7b8e6a23afd108ddb01d925e4e805da2bcaa"
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
