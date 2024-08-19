class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.8.11.tar.gz"
  sha256 "f5dd6a1f66c0bb4c50ccf75944671b481c59d66af6a924de3f7faea3a8328cc3"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9d55be304eb6a35b22960587b2bb63eb6577721a8b77328d4ee91c8a5bb1238b"
    sha256 cellar: :any,                 arm64_ventura:  "56e6c1cf0ecd9a20eaccdb26a42294c14cbab50860c8f60d05193a0aaf94f817"
    sha256 cellar: :any,                 arm64_monterey: "f0426afada5ba49bf935587d9170479950bc61b1d921e934674b1642d15266f3"
    sha256 cellar: :any,                 sonoma:         "2873def487997362f4c1cd57a74c7a5ef2fce25d6b02d33930d213c015565e52"
    sha256 cellar: :any,                 ventura:        "b18a6478884e8e8f52e37f41897efc05acc132dc3ed26137204b069f8602e688"
    sha256 cellar: :any,                 monterey:       "b388c41dda4ce8e42a8701a0914434d917cd8052fe6bd291fc9c538edd47eb50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45f844d3933e086b1574e68b39d70ef6d43b25de5205b25e81f4bd48e53a5705"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "openssl@3"

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
