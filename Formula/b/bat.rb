class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "907554a9eff239f256ee8fe05a922aad84febe4fe10a499def72a4557e9eedfb"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/sharkdp/bat.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8d57d3134c0940ff5b9b8ae47fb339e51bb7f7c307c538e8bbbc6e1751f9d858"
    sha256 cellar: :any,                 arm64_sonoma:   "7f10b2232b03e82cd9d27560e9ed7e62e685370a187c1d9ae692b9c088f7b078"
    sha256 cellar: :any,                 arm64_ventura:  "36c6ccd54c032411a7e552a010e6859936bec66ad7937ee210de8ef2a7b09ffc"
    sha256 cellar: :any,                 arm64_monterey: "bc2056fc9ac24bd33d1f8739330f25c759afad5255532547a30ecc4ebb792004"
    sha256 cellar: :any,                 sonoma:         "f6d1933c659a4073863cdad02273a9a6261770cf2bcdb8694ebd65433c49f634"
    sha256 cellar: :any,                 ventura:        "1beafb2f78e79ea2a905db10306c5944cb02a58b6b0e334d766482f853c9c692"
    sha256 cellar: :any,                 monterey:       "14e1b6003fd419f35f525667d4997c42fc044f85709563c3f02833ecbb98e3dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36182f578db0917f46fce701b68b7122bba8323524b384f3238ca325a789b97d"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.7"
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
      Formula["libgit2@1.7"].opt_lib/shared_library("libgit2"),
      Formula["oniguruma"].opt_lib/shared_library("libonig"),
    ].each do |library|
      assert check_binary_linkage(bin/"bat", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
