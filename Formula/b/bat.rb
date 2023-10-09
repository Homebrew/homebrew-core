class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  license any_of: ["Apache-2.0", "MIT"]

  # TODO: Remove `stable` block when we can use unversioned `libgit2`.
  stable do
    # TODO: check if we can use unversioned `libgit2` at version bump.
    # Remove `stable` and `head` blocks when this is done.
    # See comments below for details.
    url "https://github.com/sharkdp/bat/archive/refs/tags/v0.23.0.tar.gz"
    sha256 "30b6256bea0143caebd08256e0a605280afbbc5eef7ce692f84621eb232a9b31"

    # To check for `libgit2` version:
    # 1. Search for `libgit2-sys` version at https://github.com/sharkdp/bat/blob/v#{version}/Cargo.lock
    # 2. If the version suffix of `libgit2-sys` is newer than +1.5.*, then:
    #    - Use the corresponding `libgit2` formula.
    #    - Remove `LIBGIT2_SYS_USE_PKG_CONFIG` env var below.
    #      See: https://github.com/rust-lang/git2-rs/commit/59a81cac9ada22b5ea6ca2841f5bd1229f1dd659.
    depends_on "libgit2@1.5"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "14b72f60bc162be5d6b6eed8ced978e7b7c14dd49e4ad3c82dce35e532e3070b"
    sha256 cellar: :any,                 arm64_ventura:  "715bd9459d6ad4d47292666ecd86ac44da11875f417701e84762d74040eb71ba"
    sha256 cellar: :any,                 arm64_monterey: "d9cd7ef7a71c8a68a0684f4b09adf24d4df64ec4fbd70b39fe81a6d8c3cbf201"
    sha256 cellar: :any,                 arm64_big_sur:  "b00b1ebb963536f84c3eeb36fcf8f243ddf0fec4488f41661bae074b9301b46f"
    sha256 cellar: :any,                 sonoma:         "f6d0c0c8c48859c8dcdc1786ec36e38a59ea9f66147e8b1b343f5f9c4fe6c3bd"
    sha256 cellar: :any,                 ventura:        "8b9e019fbd1cdeb8aeff993fecc9ef411c9793e15bf86553dee983812d683de3"
    sha256 cellar: :any,                 monterey:       "e60e9f641cf9f3f896fec2fd9585fe2459471b0a7f4149e64a91e49ada5886ba"
    sha256 cellar: :any,                 big_sur:        "226c3f635e4b5a0f0acf1f5758dc6d9705b564af7c4593bd78f664387cfca6a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33a7bfc707c3fcc316912a68c4aa4e0f1a2417a5626e637316b20792d747aadc"
  end

  # TODO: Remove `head` block when `stable` uses unversioned `libgit2`.
  head do
    url "https://github.com/sharkdp/bat.git", branch: "master"
    depends_on "libgit2"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    assets_dir = Dir["target/release/build/bat-*/out/assets"].first
    man1.install "#{assets_dir}/manual/bat.1"
    bash_completion.install "#{assets_dir}/completions/bat.bash" => "bat"
    fish_completion.install "#{assets_dir}/completions/bat.fish"
    zsh_completion.install "#{assets_dir}/completions/bat.zsh" => "_bat"
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output

    [
      Formula["libgit2@1.5"].opt_lib/shared_library("libgit2"),
      Formula["oniguruma"].opt_lib/shared_library("libonig"),
    ].each do |library|
      assert check_binary_linkage(bin/"bat", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
