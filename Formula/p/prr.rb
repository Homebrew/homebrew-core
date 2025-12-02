class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https://github.com/danobi/prr"
  url "https://github.com/danobi/prr/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "891d8b2bc0397027e909750ac7891ca3d6e215acab59a48d5b2da35e60b45b8c"
  license "GPL-2.0-only"
  head "https://github.com/danobi/prr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4104e21453d0b34b7ab2b183c0d5206fd2a3a8be8e3d053988ac27028f95eae4"
    sha256 cellar: :any,                 arm64_sequoia: "c17217ab2cf5ad6349ded14664733f58db5273cab612e577dbd7aef6ef56eb49"
    sha256 cellar: :any,                 arm64_sonoma:  "a3ef5940ceafe8a6dd74d317a77d6714a69ccff78d1d77f198275acba96ba0f4"
    sha256 cellar: :any,                 sonoma:        "834ea3bb39f1f520a14afd064408a0fc4cdaa672a35e3fec3db33a6643016585"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d415636ffbe9e8e3d16707775f318c6ac944b9419d6e643f3aed7107267f43ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6e45b8471f685c0070c1f9f5197f5eec6174adcd2a0687bfc0defc66a063225"
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
