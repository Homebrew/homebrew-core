class Meli < Formula
  desc "Terminal e-mail client and e-mail client library"
  homepage "https://meli-email.org/"
  url "https://git.meli-email.org/meli/meli/archive/v0.8.13.tar.gz"
  sha256 "b1414defb7973a96ed0510b5cb888aa8671fe4f3f832c5baa0c79dcd61ba2edf"
  license any_of: ["EUPL-1.2", "GPL-3.0-or-later"]

  livecheck do
    url "https://git.meli-email.org/meli/meli.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "400789dae19d4f25196ecb0b994b0ea72bf78e77a088db599ba6e291688f854a"
    sha256 cellar: :any, arm64_tahoe:       "6ce8df59b35e71660cbd2ddc97b6fb88df0ed598b3281a34c5a605ea050ca2be"
    sha256 cellar: :any, arm64_sequoia:     "9b198a2bf1bc14270f54d0c9769034bd873ba1bf645d84f5a815da36c702df0e"
    sha256 cellar: :any, arm64_linux:       "1fe24e54576b6a811bb20ab8fd71cb480226c42b7d47588798a6ad2a077afcd0"
    sha256 cellar: :any, x86_64_linux:      "2eaff77a02ca32d9b2beff3b050da071c8f6f876954e193ecab145e846a0059d"
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
