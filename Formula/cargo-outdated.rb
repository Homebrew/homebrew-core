class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://github.com/kbknapp/cargo-outdated/archive/v0.9.17.tar.gz"
  sha256 "9311409ce07bad0883439fdba4bfb160e8d0c7a63d84e45dc0c71fbeb5ac673a"
  license "MIT"
  revision 2
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1f8e5e78dac65f29b9d9a07d270dcd424cc3e3ad0d7c7c34224c6edcd3a0817a"
    sha256 cellar: :any, big_sur:       "28864dc6c4e102e674ebf0d51a3e0967460502885a1ecb88538729ff4879613b"
    sha256 cellar: :any, catalina:      "bf285ce68e96a08d37ceb0777dcdb586635582f70ceb70e529c49adf7564f847"
    sha256 cellar: :any, mojave:        "328e96693648cd956cbe001f87d527a45cbe4318e3e4f1f2b28d89d44681f852"
  end

  depends_on "libgit2"
  depends_on "openssl@1.1"
  depends_on "rust"

  # Update `libgit2-sys` crate for Libgit2 1.2.0 support
  # https://github.com/kbknapp/cargo-outdated/issues/279
  patch :DATA

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
      EOS

      (crate/"lib.rs").write "use libc;"

      output = shell_output("cargo outdated 2>&1")
      # libc 0.1 is outdated
      assert_match "libc", output
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 6302b41..06ef1ce 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -591,9 +591,9 @@ checksum = "8916b1f6ca17130ec6568feccee27c156ad12037880833a3b842a823236502e7"
 
 [[package]]
 name = "libgit2-sys"
-version = "0.12.18+1.1.0"
+version = "0.12.23+1.2.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "3da6a42da88fc37ee1ecda212ffa254c25713532980005d5f7c0b0fbe7e6e885"
+checksum = "29730a445bae719db3107078b46808cc45a5b7a6bae3f31272923af969453356"
 dependencies = [
  "cc",
  "libc",
