class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.1.9.tar.gz"
  sha256 "e44369529d2a786361dd1fa136fea130216768f709cb623447e68f1b19637e13"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3002b1b48fb8e052c6a779ac877495e41ed21901b4ca7d17c4d7930aebf83697"
    sha256 cellar: :any,                 arm64_sonoma:  "23a384b94adc28cb0979cbfb6a493d48ceaa07bc80db91b5f3438eea7c2c657b"
    sha256 cellar: :any,                 arm64_ventura: "3000f4f78e2f8ff50a1834d3456a28e2a5838d551aff61ecad73c791237e8dfc"
    sha256 cellar: :any,                 sonoma:        "7be6566d564aea0c0a1954bcfc3b83d641e4246880cc9b859cd6c1c92cf2d7e0"
    sha256 cellar: :any,                 ventura:       "4fe342b53d518667e5288c18ed9310518b959bd6eecf9dc5317591578ca8bba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ab00d1368bbfaf3a918c14df36b2c1a0474af0f8008541f53c39a473884560c"
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
