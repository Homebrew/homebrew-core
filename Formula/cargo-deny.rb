class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.13.9.tar.gz"
  sha256 "b26d8f984e00ddf96766e25781d6b296ff7a571f2c3730a607bfde24062b8adb"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d7313f29a24ba4ba12c11adfb2191775f1d708e3a57f4e02a332b2e8736e6657"
    sha256 cellar: :any,                 arm64_monterey: "296f2d5b36063deac24f82f69a4290be11471b503dd255955abad8053c8fd1a3"
    sha256 cellar: :any,                 arm64_big_sur:  "8361965027fc916f1cb1dc8bd66d8f021ad66e1829de43055bd35de877d1761c"
    sha256 cellar: :any,                 ventura:        "8e74e5432a2668d5ef992e9d24e1c69567f7ef7abd3566c25df4d3974ebe3058"
    sha256 cellar: :any,                 monterey:       "47e3d92a3309a4f86c0a4199c7beb995a8566851cf958e40c1330db3f3f87b05"
    sha256 cellar: :any,                 big_sur:        "17801468c4bdf1ed5d6c3ebe2e110db029cc48eae699dff3725e9e251aa6d5b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b7e106df432c503fa28fd4c3f4233275cfd667a9fe1e1288c039500ec7bab1e"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "libgit2@1.5"
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
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
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo deny check 2>&1", 1)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end

    [
      Formula["libgit2@1.5"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-deny", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
