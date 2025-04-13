class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https://github.com/danobi/prr"
  url "https://github.com/danobi/prr/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "fa25e4690a6976af37738b417b01f1fa0df7448efd631239aadea0399a9e862a"
  license "GPL-2.0-only"
  head "https://github.com/danobi/prr.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "020e2b1af8b7a3f2b1f39096597b06e80e338ff308a50d8f9f4b73094728a12d"
    sha256 cellar: :any,                 arm64_sonoma:  "43547eb2228e9fa399f34b9bd5202fbe7aed3257095a1a93f75a667d36d8658d"
    sha256 cellar: :any,                 arm64_ventura: "1ae08fc4c7d6625baf22b16df0cf1178efee1f699bfc25c6bb961f3f7560f75e"
    sha256 cellar: :any,                 sonoma:        "ff40fe06171b1047bfadd9391918a99f47090ba502584677085052764ff8f71b"
    sha256 cellar: :any,                 ventura:       "a3bad778d1010031a272e32535c8ed6c9e487aa0587de878350429f5683cb5ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c096eed0ee69a0b6e4e5d7ebd12357edd22d0c2b61d93e3d5b2c2625f216ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f78629fe312045ec89e5377a86cf1c165eca5c5ff60114100a111c0ccfe60eef"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    # Specify GEN_DIR for shell completions and manpage generation
    ENV["GEN_DIR"] = buildpath

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/prr.bash" => "prr"
    fish_completion.install "completions/prr.fish"
    zsh_completion.install "completions/_prr"
    man1.install Dir["man/*.1"]
  end

  test do
    require "utils/linkage"

    assert_match "Failed to read config", shell_output("#{bin}/prr get Homebrew/homebrew-core/6 2>&1", 1)

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"prr", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
