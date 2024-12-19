class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.12.15.tar.gz"
  sha256 "c79a6bb385e71749834bc3d6ebe1b3d1f399f2be18027d8d6dc1d633653ae445"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3990c70fb93925448a1a6aa1e37d3dc98c659baa630fc9b81fb5fb4827f9374f"
    sha256 cellar: :any,                 arm64_sonoma:  "81c241bb2fe4c0d0010cafabe87608c403174f64206fb337a86c2ec5be19fcf4"
    sha256 cellar: :any,                 arm64_ventura: "0ad673582ac652be34d38def83a12f0c765d13a4ebf86291efc1ec66adcfc0c1"
    sha256 cellar: :any,                 sonoma:        "fe8aad708e6570a2847dbb409b8e8990f8986ba175e56d993c2a351a2ed833ea"
    sha256 cellar: :any,                 ventura:       "a2d6af963f66d7f301726cbb0fb5ce9787e6c8838593779354f952286bdad4c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2793060ebd383aad14549179c700b818520631bd5f3dadce4810d9fb801d0255"
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
    generate_completions_from_executable(bin/"mise", "completion", "--include-bash-completion-lib")
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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"mise", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
