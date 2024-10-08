class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.10.1.tar.gz"
  sha256 "cd6a558b514468aaaf2f878b9e99f4ce6421857f341d8c99a45b56f76e633709"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "62c4bf676bae1a59f74cba8a70cf52d8b6c9752684e75f659ded3d94ca20b1c4"
    sha256 cellar: :any,                 arm64_sonoma:  "1109f9069d3e49733785278eab657768ae306d970be2808895a97c8dbe0d9a65"
    sha256 cellar: :any,                 arm64_ventura: "887c72b6dd7cc0be31afee1864dbedc48c3171976570342ebc18e14bc8347c04"
    sha256 cellar: :any,                 sonoma:        "ff750d91907637801a8771ac87feb628f413672c316ace4d79150470f29e6bed"
    sha256 cellar: :any,                 ventura:       "fb485a53c4a80e3d577a6aa46ed83bc9e755cc671190a7da0202c21fe7e0d039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a783e9bbd4eadd83944c89c16655c29c8d7db9ac3a4f3f96ba1307ad55f1547a"
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
