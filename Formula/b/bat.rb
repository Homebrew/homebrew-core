class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/sharkdp/bat.git", branch: "master"

  # Remove `stable` block when patch is no longer needed.
  stable do
    url "https://github.com/sharkdp/bat/archive/refs/tags/v0.24.0.tar.gz"
    sha256 "907554a9eff239f256ee8fe05a922aad84febe4fe10a499def72a4557e9eedfb"

    # Update libgit2-sys to support libgit2 1.8.
    # Backport of https://github.com/sharkdp/bat/commit/c59dad0cae45d7aa84ad87583d6b6904b30839b2
    patch :DATA
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "551f2475fea64abf18cc89dd3d7b5b81025f1eea76ec9822931698746252c7b6"
    sha256 cellar: :any,                 arm64_sonoma:  "6cc195324f99c03418d089b273b581856ad80876845898c3e932d843ce9b36d7"
    sha256 cellar: :any,                 arm64_ventura: "cdf2086708888cbf4196097e7970faefa5d307d1af1596318cad3e40125952a1"
    sha256 cellar: :any,                 sonoma:        "ef586d39057da2d71132ff3828a787602865895305a314356fcd91d2ad062736"
    sha256 cellar: :any,                 ventura:       "34437a8949ccf6c038623ed61c5a1741a60ac34a8fd09f55eac283485e780458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9b46511808dedc8e88fe9a7194adee9d873e84c32a22a5fdc2b66f13cf35b56"
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

__END__
diff --git a/Cargo.lock b/Cargo.lock
index d51c98a..90367a0 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -523,9 +523,9 @@ dependencies = [
 
 [[package]]
 name = "git2"
-version = "0.18.0"
+version = "0.19.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "12ef350ba88a33b4d524b1d1c79096c9ade5ef8c59395df0e60d1e1889414c0e"
+checksum = "b903b73e45dc0c6c596f2d37eccece7c1c8bb6e4407b001096387c63d0d93724"
 dependencies = [
  "bitflags 2.4.0",
  "libc",
@@ -658,9 +658,9 @@ checksum = "b4668fb0ea861c1df094127ac5f1da3409a82116a4ba74fca2e58ef927159bb3"
 
 [[package]]
 name = "libgit2-sys"
-version = "0.16.1+1.7.1"
+version = "0.17.0+1.8.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f2a2bb3680b094add03bb3732ec520ece34da31a8cd2d633d1389d0f0fb60d0c"
+checksum = "10472326a8a6477c3c20a64547b0059e4b0d086869eee31e6d7da728a8eb7224"
 dependencies = [
  "cc",
  "libc",
diff --git a/Cargo.toml b/Cargo.toml
index e31fbc3..5fb32c8 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -69,7 +69,7 @@ os_str_bytes = { version = "~6.4", optional = true }
 run_script = { version = "^0.10.0", optional = true}
 
 [dependencies.git2]
-version = "0.18"
+version = "0.19"
 optional = true
 default-features = false
 
