class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.12.6.tar.gz"
  sha256 "c8f41169d6c9c44dd754ea47cbd83f85b0ba01d721fdbe68f71b30abe05d26e3"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0ea4e6d6103989761cfabfddcb06a74b3ce0edb6c8af9f45f1ca4d5928d59345"
    sha256 cellar: :any,                 arm64_sonoma:  "469a86b2adb365e9cb5424fbc6ec76fbf0e2c63ad148d936f634cecb90c4ba0e"
    sha256 cellar: :any,                 arm64_ventura: "c53b680406205b762b5c98b30a75e9ac6f37f940f28d360c8c4bb201d4c8f421"
    sha256 cellar: :any,                 sonoma:        "26ccb13c7107e0d2c8a64943733f71ace5a9a5efbbe5aefb64969b1c0bd28422"
    sha256 cellar: :any,                 ventura:       "4435e08fa8e3935216c2c60722c22f4316ce6893fd686327385094a70e56f496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eadb9d840f11dc36c21f3da00688c206e536749d56a05450dc3bd8345dd45de"
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
