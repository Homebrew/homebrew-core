class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.6.2.tar.gz"
  sha256 "52a12dfe9417ba34247e16a4802187dd324c1048bb0afdfd987aa442a5ed9d7d"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fa22b51761e03c0ae667652812de8304e1acc0dd95c016f297cccf11c8e18589"
    sha256 cellar: :any,                 arm64_ventura:  "0f22e7ceeee6c03805d1e46d19fcc3a4f65b53d167148efdc2ad7ed62e4167e7"
    sha256 cellar: :any,                 arm64_monterey: "2757108b9647e5c8c285b778e8484a84be63489db2b30f5d7bab24f3d6b2baaf"
    sha256 cellar: :any,                 sonoma:         "10ef30336316e099f3773629a0c08ae8f5e17c3dddebce61fd7d7cff301e1515"
    sha256 cellar: :any,                 ventura:        "d1e9bb2dcc3a2514cd00c64bf8d1d5c184711d5e771bd74b11c183c5cc2589a9"
    sha256 cellar: :any,                 monterey:       "dc94cdd4b1b362785e6e005a52274c6f778ee275dea9c93749ed62357d3313ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adf593c396ef468b3c23508f0af9f4aba01e43e9ce0b03ea2a9530481830db4d"
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
