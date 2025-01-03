class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.1.0.tar.gz"
  sha256 "51e56a831cbedece92b1e3e5eaad92afae9d133503881ad18f229ea41e24a618"
  license "MIT"
  revision 1
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "46bcc766c5d6d7da4c937d40850d787d1cfb11e013e104a18b258a617cd2f2bb"
    sha256 cellar: :any,                 arm64_sonoma:  "49cda77fdf35ed092bb3a4fbd2843bc0526b93958a367fe541e333a7cd9b531a"
    sha256 cellar: :any,                 arm64_ventura: "a45b8c3e5faaff7fcc6ea15a96bfe4c35b9c75a263f9f86f9e87ee514b7b459b"
    sha256 cellar: :any,                 sonoma:        "6d41f8d3fcb638391bd8d90ed3957c935fadcba6360918821f984a605f4d66ed"
    sha256 cellar: :any,                 ventura:       "48326d6d80a44a2a38c35e976e864c391f226374d616b9b4c7962340bf5dbce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee943f018a705141bdc9d7673938c6658de88c46a915ded8eb6b31cc5ca20004"
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
      Formula["libgit2@1.8"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"mise", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
