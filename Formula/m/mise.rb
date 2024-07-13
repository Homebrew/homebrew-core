class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.7.2.tar.gz"
  sha256 "4a707ae0d27c6b64c42fac1a2abbb73da78b214c3f31828131789d7de4a88d92"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4228f110f4d6c20c134518bb906a5df4819edcebcbb414a0a9a1b5f0de677fd5"
    sha256 cellar: :any,                 arm64_ventura:  "263f20ff73a6b2080042a932df95e48d058a6c54d419249bd0114098701cc412"
    sha256 cellar: :any,                 arm64_monterey: "a3999a0028e8599008c5a1270b6915f0db854ccc2e04afe8ac39558e68431384"
    sha256 cellar: :any,                 sonoma:         "ef919826800e7ab9c2d385be0da97a8a827e90afc6274994591ba6fe18f5f3ce"
    sha256 cellar: :any,                 ventura:        "4991444e35d59e0a511f9fc40c02423f9c7cdf11e74d09de9ad250dc854df84e"
    sha256 cellar: :any,                 monterey:       "28fee14f5d9dc5966fcbb98c68ca2cdd0d3519988db97e156366c8494681fa83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a78354d1be8683eb8d8e60767e254f98d9560ec91efde0f07c5b13a61af25ed"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

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
    system "#{bin}/mise", "install", "terraform@1.5.7"
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
