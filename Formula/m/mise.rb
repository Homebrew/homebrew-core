class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.11.22.tar.gz"
  sha256 "cbacbcc7cec8359dc13114b723800acd4a18be3a9f71032cf18528facae5bf7c"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dbc78433099b994594358ec03822599316421137907131dfdd7ad7cdd8e08439"
    sha256 cellar: :any,                 arm64_sonoma:  "6d303a504eeb6ba79f356ff45de4dde1d52806cbf994a74931edbcf30cd02ab2"
    sha256 cellar: :any,                 arm64_ventura: "581bd2184ba58efee532d0a376e789e073491ca55bd2767e8bc0f8ddf6bf8746"
    sha256 cellar: :any,                 sonoma:        "89a1d84bb887a29fc1cdddaa3d7d0b1a6d997a7c3db56fb434e66841b74a8560"
    sha256 cellar: :any,                 ventura:       "23638808dc6d0a16b7b98374d239b70b1908bf6970b212617c4d567c81f4ebbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b23aae2e00aaefd22889f2d516615a2085fd0462709c0f1d0a8ef41ef01337aa"
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
