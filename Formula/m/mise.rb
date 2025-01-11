class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.1.5.tar.gz"
  sha256 "be4ea0095e80558548caff2f5452c6e3bd2a61d5bb67dffc9ef7fd321f7de4b2"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0e0a3581a80431f32f13f7a69204f68a610bd23eec70fd08d92ede329450fedb"
    sha256 cellar: :any,                 arm64_sonoma:  "42fcf1de7247bcfc6cbabf8e7f79a105ddcbcdabe9e37c448b1c0455bbada9e4"
    sha256 cellar: :any,                 arm64_ventura: "20540c199e6152e4c85a79d21b0440448fd975c18c3c7a7f15eadfd7a6f5c5bb"
    sha256 cellar: :any,                 sonoma:        "21dc3d97a836efe6d57e8cdfc87efea5c549fd34507b87ff95e4f5ba46d9d4e3"
    sha256 cellar: :any,                 ventura:       "d6ef47ac67315e28fe3f59845de12ad0deab869f25f09512355065d89bf0df99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7533d5b3d6ff6d2719726421ec48ba80945c4246d890db4d103f5fece2a445ad"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2@1.8" # needs https://github.com/rust-lang/git2-rs/issues/1109 to support libgit2 1.9
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
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH
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
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")

    [
      Formula["libgit2@1.8"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"mise", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
