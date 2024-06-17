class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "907554a9eff239f256ee8fe05a922aad84febe4fe10a499def72a4557e9eedfb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/bat.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "66f03028e55d7a9ce344c7910b8469e16c0acd812ebc2886cdff8c10f9cf34c4"
    sha256 cellar: :any,                 arm64_ventura:  "b36dd52fda8441a5b9c83f0914b4f362c8caa9c6a1143b1ee2c7f54941b8ed6b"
    sha256 cellar: :any,                 arm64_monterey: "0a7454b37d7b095de1006996ceb43a585ca05339c2f540dde1703202b139695d"
    sha256 cellar: :any,                 sonoma:         "58769b8c6b1380e9d066586bf8f678993457ef9ea449c3d4d7955461018d3b49"
    sha256 cellar: :any,                 ventura:        "d6e91c86547c67292cb6abf92fac7f9c6272bf6bca5483466e3e9adc744ce1c0"
    sha256 cellar: :any,                 monterey:       "eb2c932132331cb87e5cace268b034e32c3a4741fccd42813cf853269e3a9c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ae5db045ded8528d1588d703d62d6be481ebe006888c7e29f7e178b07e0e926"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "oniguruma"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["oniguruma"].opt_lib/shared_library("libonig"),
    ].each do |library|
      assert check_binary_linkage(bin/"bat", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
