class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.8.5.tar.gz"
  sha256 "38a7d5da54b8089202c7fc576a0310cc06a422e4ee2e3c5980439eb2e602495a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b61d0974086d5ad7d21b439ccd9cc3b5ed7050d78f7b48bbf95f541e27e41ad8"
    sha256 cellar: :any,                 arm64_ventura:  "df79f3546fbe6ff48730e740b5efa8b688f577e3d2050f0d13a1e20040c8c214"
    sha256 cellar: :any,                 arm64_monterey: "13a0888259359bd55b3960aff1d18de2e2274140501665ae825aa69513c24359"
    sha256 cellar: :any,                 sonoma:         "20ac346ad81c92648435f5c7e4b04465f4a857583854c93bf6846904e02b9c67"
    sha256 cellar: :any,                 ventura:        "82f9a252b6a9a1f6320ccdd1e5915ae7469a7fc4c458a793ed2b03d284c5671e"
    sha256 cellar: :any,                 monterey:       "398850f71c3819d6b095530747766dd753b36cbe6882119b962eede2bc31c364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c93023cd04f85c1f8641f62266a924cdaa66c14de5140a1d28b89be36cd3677"
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
