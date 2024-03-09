class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "838123d01370570c7170471103263b460ecff3c2ad3298edbe0d4f3e59e7798b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3fd8dde9d3d9a929ff034da5f768c48d0b477665cd8b4575a766d88911d972fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aef60403fcb1716003f89d86447a604fba169690778a7691757bd399e365eaaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "088a11ce71da1e2cb59460b7e5d1fed69e8253f9fab757615b9547317b16c46d"
    sha256 cellar: :any_skip_relocation, sonoma:         "535b0ed0eee6eb82f4b8ca23bf436d7ef955cd75575fd2903119e502642e0cfc"
    sha256 cellar: :any_skip_relocation, ventura:        "cd9acc0e3a7aa94f4aae75667876ed53388fbeddc53bf9ce072fd69f91fefdf2"
    sha256 cellar: :any_skip_relocation, monterey:       "83528dccceb491d68db3a6a4a75c6abda710eac5b3d7c51014dee2df0866425c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "954df11db7d88894168199777078250b06d06f22c6ca9b359f1951868ac89ecb"
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
