class Gitlogue < Formula
  desc "Cinematic Git commit replay tool"
  homepage "https://github.com/unhappychoice/gitlogue"
  url "https://github.com/unhappychoice/gitlogue/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "a2376359c8fa878da94b273513fad649085ce3c4a4d4efd61acb124530172e7e"
  license "ISC"
  head "https://github.com/unhappychoice/gitlogue.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "692a588d8605083d3cad577dcc6e83b89fb27ae196456c106bf99fbf24af2e85"
    sha256 cellar: :any, arm64_tahoe:       "1c9d94b648a8bd4984bd582a307acd341772a9e64d1ef826ff1c2d830068220e"
    sha256 cellar: :any, arm64_sequoia:     "03fc6f50e4e7374bec95db10e79f42b7e6131fd238899e2322ea45b3597d5c32"
    sha256 cellar: :any, arm64_linux:       "93b991c8510567f82f7188f589e4dfe9eabbf73cf8216b42497d78f85a63d059"
    sha256 cellar: :any, x86_64_linux:      "36e03fcce3e1ef9f016787ea20e2ea49ff49e2b7d270455b83c4ee1e1bb3749c"
  end

  depends_on "openssl@4" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Update to openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  # Issue ref: https://github.com/unhappychoice/gitlogue/issues/226
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlogue --version")

    assert_match "Error: Not a Git repository", shell_output("#{bin}/gitlogue 2>&1", 1)
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 698ae5b..ce63719 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1197,9 +1197,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.111"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "82cab2d520aa75e3c58898289429321eb788c3106963d0dc886ec7a5f4adc321"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
