class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https://github.com/danobi/prr"
  url "https://github.com/danobi/prr/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "891d8b2bc0397027e909750ac7891ca3d6e215acab59a48d5b2da35e60b45b8c"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/danobi/prr.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "24efacbb035270ba41aefb9298868d351f09c11589f430527c5b21e5258e3a36"
    sha256 cellar: :any, arm64_tahoe:       "f1d54ebcee2b12a89ebdcdcab4f3a9a1a0ae1f215e1b51185164572c7570886a"
    sha256 cellar: :any, arm64_sequoia:     "53b7727e39b3fbec7ef98c7297990de92cd34f6ca2f25d63a4b8c475fdcc0fa4"
    sha256 cellar: :any, arm64_linux:       "493458c91ad74ad40dd7a5644c72fa6e084ee24fd94a8d1fa64b0534522c4d54"
    sha256 cellar: :any, x86_64_linux:      "48c6aa69c09011532fbd22b4030e94a2007f5ed3108ab6b1292a5759d1f7b264"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # `cargo update --precise 0.9.114 openssl-sys` for minimum needed to use OpenSSL 4
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

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
      formula_opt_lib("libgit2")/shared_library("libgit2"),
      formula_opt_lib("libssh2")/shared_library("libssh2"),
      formula_opt_lib("openssl@4")/shared_library("libssl"),
      formula_opt_lib("openssl@4")/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"prr", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end

__END__
  diff --git a/Cargo.lock b/Cargo.lock
index 54b9a55..3cf3b7a 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1075,9 +1075,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.109"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "90096e2e47630d78b7d1c20952dc621f957103f8bc2c8359ec81290d75238571"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
