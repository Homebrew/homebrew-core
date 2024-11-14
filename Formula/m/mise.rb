class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.11.12.tar.gz"
  sha256 "65598c09fabd0b8435cf5ab3f02626f556376d27e65501cc8572e54c97a40ad8"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0455c567ae6526e1f6e82015d23d2c77ec2a6eba2027a2a7d564e62c3d5a1549"
    sha256 cellar: :any,                 arm64_sonoma:  "a03a7c72449ed21301790cb8199339d38605dd9ea953578498c7aa4927103ce7"
    sha256 cellar: :any,                 arm64_ventura: "df237f0e3cc181aa93b4986253838fec1e0785cfcf44b93628911d4d462c72b4"
    sha256 cellar: :any,                 sonoma:        "a11362fda7cee877301f49e3abe9c218c6767f84e0846e81c79cc3b3e4878b0f"
    sha256 cellar: :any,                 ventura:       "9b7ada518c0273ff23a338d723e36677da785bd2fa10badd0c490dad976f06f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59f6a9f2140050779ad80a452a240fa290b18856380201bce8c93c4fd11f2b37"
  end

  depends_on "pkg-config" => :build
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
    system bin/"mise", "install", "terraform@1.5.7"
    assert_match "1.5.7", shell_output("#{bin}/mise exec terraform@1.5.7 -- terraform -v")

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
