class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.12.19.tar.gz"
  sha256 "2bd1e158156c6f3df69292456b88ccf0e2363d4e82a4856edd3a2d47b86d7ad6"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9d35481ee6c7eaf668b72ecde3d468493691ef9aafbd1f0aaeceb08256196666"
    sha256 cellar: :any,                 arm64_sonoma:  "5c3fc924f251d8e99f18abab6d2b0c1397e82ee25a0f6f9f8f9bf44e1d22358f"
    sha256 cellar: :any,                 arm64_ventura: "de98faa5c6117b84b987494844b591b7f0fac2f0b0eb0cc952b3623bde2c08d8"
    sha256 cellar: :any,                 sonoma:        "9ee778da9260809d9638dff8892c1d7cac42f48cbce3cd07324e087e96f05604"
    sha256 cellar: :any,                 ventura:       "abe93b20e7d0ce130c7e8eb20ef10511abe532afe7a76615a765fb6d7dce9c6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb5e4afac74cef267fc948f7f84fb586b2199b3c2a563187b7e798e6916dbd55"
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
