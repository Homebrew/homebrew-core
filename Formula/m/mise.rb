class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.10.7.tar.gz"
  sha256 "f651eeee53de37f0ee615e0a60744e00a9abe76d5be574fcf24c7072f835efdf"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bf5859cb13e7fc5e97f83a08df692b4140d410979bd8fbbfd4bbb6390b20263b"
    sha256 cellar: :any,                 arm64_sonoma:  "7d83e6c7d86b75a244bad3ec07e0616e28fe3c2c0c92ccc518affeaf2ab1e827"
    sha256 cellar: :any,                 arm64_ventura: "aa25d660ddf128e848c988bf7a3f96761c764f0830969a6e38ff23f1e865bc72"
    sha256 cellar: :any,                 sonoma:        "37bd8938264f02b7a7270e13a8900d5064059fd70ec88f502b1295857ea9a68f"
    sha256 cellar: :any,                 ventura:       "953230731b1a87ee5f277e4c16fb15ad4533938c71356641e6cfaf3992579aa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "442cb0bd66b1d9eb99084b8d81868cbd3e37f38c2e92144d4c041c10a9113609"
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
