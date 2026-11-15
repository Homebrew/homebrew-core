class Meli < Formula
  desc "Terminal e-mail client and e-mail client library"
  homepage "https://meli-email.org/"
  url "https://git.meli-email.org/meli/meli/archive/v0.9.0.tar.gz"
  sha256 "4eeca49cfef7c9a7c65f722d5fe1b17e3aae85703fb6cd6428c9a53edffb9edd"
  license any_of: ["EUPL-1.2", "GPL-3.0-or-later"]

  livecheck do
    url "https://git.meli-email.org/meli/meli.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9f23d84e82737440694c0f0cfd7fb3169024a9bf8bb8206d2d587f5e8daceed3"
    sha256 cellar: :any, arm64_tahoe:       "8fbbfc465d353040699883c77d43b81094f4baca29f62fd3aa3c144ee1d06992"
    sha256 cellar: :any, arm64_sequoia:     "c13ef814e01243533236abe641efc2cac46a82ba4bf8c711bb0a7a6a193716a2"
    sha256 cellar: :any, arm64_linux:       "cf1a1b25f57355c71eb2fddfd2c45c8327892dabd8be56bbe652202cd5dd8bfe"
    sha256 cellar: :any, x86_64_linux:      "691c0cc0e18bb0b648c644766622627c61101c698566b4f80c9f67500939f664"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"
  depends_on "sqlite" # needs `sqlite3_unlock_notify`

  uses_from_macos "curl"

  on_linux do
    depends_on "dbus"
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"

    # Remove static feature from default features
    features = %w[
      sqlite3
      notmuch
      smtp
      dbus-notifications
      gpgme
      cli-docs
      jmap
    ]
    features += %w[http sequoia] if build.head?

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "meli", features:)

    man1.install "meli/docs/meli.1"
    man5.install Dir["meli/docs/*.5"]
    man7.install "meli/docs/meli.7"
  end

  test do
    output = shell_output("#{bin}/meli print-config-path")
    assert_match (testpath/".config/meli/config.toml").to_s, output

    assert_match version.to_s, shell_output("#{bin}/meli --version")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index c35ceb28..7337ba1e 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -2277,9 +2277,9 @@ dependencies = [
 
 [[package]]
 name = "openssl"
-version = "0.10.73"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8505734d46c8ab1e19a1dce3aef597ad87dcb4c37e7188231769bd6bd51cebf8"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.10.0",
  "cfg-if",
@@ -2318,9 +2318,9 @@ dependencies = [
 
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
