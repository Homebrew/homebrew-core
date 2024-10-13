class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "cbea9b09fe0d9d577723007e1c7ef8329f7cb36268ad042bb870b63dbeaad323"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b9d75c2816fb85e86c7063c24eaee49e0312548102ecf5c76d07cd30cb5abb75"
    sha256 cellar: :any,                 arm64_sonoma:   "b7c2aa1cf4d9399a92393095be0d0db98382c4134a5d23b2e690db38c3fa998d"
    sha256 cellar: :any,                 arm64_ventura:  "ebacfd69ba9482f1bb85bbb216e43f04706e69156cb0199607bc4b86d6cc83dd"
    sha256 cellar: :any,                 arm64_monterey: "3deb80088b59d79b13fefb9ac189af1220b8269e39857fbfa1df7610fe0a95a0"
    sha256 cellar: :any,                 sonoma:         "e0d5693494cb6763204f33499965ce4954918751c0caae64f9de3a2427fccce2"
    sha256 cellar: :any,                 ventura:        "caea467b6b29979e1d5d5040ef5839a5fe2ce1c1e94a87759a9b9838cfd5c30b"
    sha256 cellar: :any,                 monterey:       "fdc8e442a0bd311e2dcc420ca98aa513d632e320edb7fb7cfa3cad32351c3b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "515399398dbaba43f5fa4225df8334c28b620e1e0e486771010fb6aeef6fb0ee"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "No favorites defined", shell_output("#{bin}/cargo-generate gen --list-favorites")

    system bin/"cargo-generate", "gen", "--git", "https://github.com/ashleygwilliams/wasm-pack-template",
                                 "--name", "brewtest"
    assert_predicate testpath/"brewtest", :exist?
    assert_match "brewtest", (testpath/"brewtest/Cargo.toml").read

    linked_libraries = [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"cargo-generate", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
