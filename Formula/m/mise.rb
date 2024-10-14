class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.10.3.tar.gz"
  sha256 "2e447d07f60273c867ded91b8e5b3a8e0a8e416eec5adeb0eabb6b61472ea013"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dc8cd49cd10d48fd4665de0fe6155150d42304ab9046955ca6418f058b7776d0"
    sha256 cellar: :any,                 arm64_sonoma:  "535d7256542a59b2963e610f23788d0a6f0c49ac5ccf18524bbe70fb3af6a0b6"
    sha256 cellar: :any,                 arm64_ventura: "48ee66fb8ddf5e9408fdeadc492a313af39c35b68ef178c7cade5ba540bf35b4"
    sha256 cellar: :any,                 sonoma:        "614e5749263093afab0a6803c2db60f9daba39f172a486a6b929eea676ff163e"
    sha256 cellar: :any,                 ventura:       "67f621e4d88a414d70949f41c6bfc0839d9b94f4e4fb49553f119cca0849ee1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ec91437131c08647b7cba39a8611b23dce7333303c025b630a4db165c1829eb"
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
    system bin/"mise", "settings", "set", "experimental", "true"
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
