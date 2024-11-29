class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.11.34.tar.gz"
  sha256 "fb04616c3e06cfc547aecdb1b455a9fb2f883bebfd66c8a7d94bff28756f9ce5"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "29a42b8827978f6101c34e48fe3df7797ce523c50555321c198f0ee4b7762c9f"
    sha256 cellar: :any,                 arm64_sonoma:  "f1a97b86aca25389cb5c3216560fed4fff5430ce4c2574c4b0a0c54f1660c9c6"
    sha256 cellar: :any,                 arm64_ventura: "6eb58a02f95f9b4534844fb17fdda3f6521002da023b9cec07f7b513bc4e5280"
    sha256 cellar: :any,                 sonoma:        "22639af08d7b5136bcaa7058e81af684a07cfab1b568e879284f392add6fb69d"
    sha256 cellar: :any,                 ventura:       "dcbe804e348d56704b5050d1d60357004428a016f1d1962c6d7fd1145eca21c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c53955e085e14a61c04a253b3192c237e351f7a716583e498f9b291d144ffc0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "openssl@3"
  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "xz" # for liblzma
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    generate_completions_from_executable(bin/"mise", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~EOS
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "node@22"
    assert_match "22", shell_output("#{bin}/mise exec -- node -v")

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"mise", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
