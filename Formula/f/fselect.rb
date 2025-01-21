class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/refs/tags/0.8.8.tar.gz"
  sha256 "0f586c3870a66d4a3ab7b92409dcf0f68a23bd8031ec0cc3f1622efebe190c9e"
  license any_of: ["Apache-2.0", "MIT"]
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "d1028fcca660a0a1876cd8ad5d92314dff3ee6fef54fb10bffc59cabfc9c1dc8"
    sha256 cellar: :any,                 arm64_sonoma:  "a9acdc57d9a524f57854fcc56baeb3424bcc9df9312f90e32a6d1154d35ea9bd"
    sha256 cellar: :any,                 arm64_ventura: "dfebd2f2eb389bb277d9d36891d6119bec6874c6b7d3a1ebf2fdd9ec924c9cf1"
    sha256 cellar: :any,                 sonoma:        "3244d215731477c373e75589d09c48e408fe17c52b97412beb92a774de8ae920"
    sha256 cellar: :any,                 ventura:       "d93fa6b4d3a3e8e04a79f3c14423e8e6b5c4291c873c4c66c04b0bd0beb4911c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cda28ae154ab74d840102f543cbab87ca90e53f03d60e907cb9f7209e80042d0"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # libgit2 1.9 build patch
  patch :DATA

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp

    linked_libraries = [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"fselect", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 1df37fd..3845112 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -650,9 +650,9 @@ checksum = "07e28edb80900c19c28f1072f2e8aeca7fa06b23cd4169cefe1af5aa3260783f"

 [[package]]
 name = "git2"
-version = "0.19.0"
+version = "0.20.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "b903b73e45dc0c6c596f2d37eccece7c1c8bb6e4407b001096387c63d0d93724"
+checksum = "3fda788993cc341f69012feba8bf45c0ba4f3291fcc08e214b4d5a7332d88aff"
 dependencies = [
  "bitflags 2.6.0",
  "libc",
@@ -1074,9 +1074,9 @@ checksum = "5aaeb2981e0606ca11d79718f8bb01164f1d6ed75080182d3abf017e6d244b6d"

 [[package]]
 name = "libgit2-sys"
-version = "0.17.0+1.8.1"
+version = "0.18.0+1.9.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "10472326a8a6477c3c20a64547b0059e4b0d086869eee31e6d7da728a8eb7224"
+checksum = "e1a117465e7e1597e8febea8bb0c410f1c7fb93b1e1cddf34363f8390367ffec"
 dependencies = [
  "cc",
  "libc",
diff --git a/Cargo.toml b/Cargo.toml
index ff8c0f0..abb5a71 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -23,7 +23,7 @@ chrono = "0.4"
 chrono-english = "0.1"
 csv = "1.0"
 directories = "5.0"
-git2 = "0.19.0"
+git2 = "0.20.0"
 human-time = "0.1.6"
 humansize = "2.0"
 imagesize = "0.13"
