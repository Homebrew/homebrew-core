class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https://github.com/danobi/prr"
  url "https://github.com/danobi/prr/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "891d8b2bc0397027e909750ac7891ca3d6e215acab59a48d5b2da35e60b45b8c"
  license "GPL-2.0-only"
  head "https://github.com/danobi/prr.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "9c3bcf26ee3499cc61c3f13ab5f4c72d35bf9780eef19fab281886d2b9e183c5"
    sha256 cellar: :any,                 arm64_sequoia: "ebe1a8d1c0424beef41dfd5ffea04da5448a2485a5264cf1cbb6e0220b369b64"
    sha256 cellar: :any,                 arm64_sonoma:  "89471d55c03628ae324dc40a042b8641e8212a2fd5b4480ca1f7a16c9259a2da"
    sha256 cellar: :any,                 sonoma:        "8349897e19839be43735a7f95e7437d2892f655aa35b7aec58bf29d80127fc49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "721d5359cc5e2b68b5951ad89e783c96bd300111c2eaa1a71d89b15147e98b42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b427337f5afde43310564971d2e70f3f683f0f7347de5e9f3f59edf8dd0f2fd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
