class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.12.14.tar.gz"
  sha256 "2428bc705774a735385a55726c32b9b3e05070214f9ee8d92d6d8455c9d37db6"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5e5c7309422a5533a82bdc5c07c2196f881f864e1404c9799248b3b8181e4864"
    sha256 cellar: :any,                 arm64_sonoma:  "f0efabd6a1d50e644a62173f8de4c69d320ef908f69ab48101ab642841e3e0ba"
    sha256 cellar: :any,                 arm64_ventura: "ca55dc49edf78c2faa04958c98f54ceafd85f414064e4fc5470dccc3ecfcc6fb"
    sha256 cellar: :any,                 sonoma:        "298758f5b90f7d76c64dde339727db197b9655e8373601f82c78d5debabccb53"
    sha256 cellar: :any,                 ventura:       "255c02fa704a1db6e524a96dea5136ff071356219e37fb8d7eb9f6ad75c167ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4a724fa370f3f1dbdd553c9623a9de332bda513d73e96c988cfb7dbc2239611"
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
