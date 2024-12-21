class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.12.17.tar.gz"
  sha256 "8f29224ab72073d1da8d3c1527fe2c735d1b9f61a83e866d5af40d2327628543"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "00c9f0779abbc5fe9fb0b7b4bdad50a1a8441712e316c19d8d0786b44d45640e"
    sha256 cellar: :any,                 arm64_sonoma:  "2b5d59943352932b03d917032164db7430e7b92699463102ea1f47fec540e701"
    sha256 cellar: :any,                 arm64_ventura: "fdfb40d1f534a1337473f6e770df0b309ffc01c8ef0e4182dc28f80f802711fc"
    sha256 cellar: :any,                 sonoma:        "3c4c09ef66e1d8ed34707d24d84bffcf2a85a0d5277cbe9afff5b4eb0cee1297"
    sha256 cellar: :any,                 ventura:       "2c09c78f8398f6f1d5254e3cf05f991b5d573f83d21d9b06d8a67f1919647613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20c63ea67d0415e398cdda1f187acb84663eed03fd0a7348090ada4269235efe"
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
