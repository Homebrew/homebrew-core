class Modsurfer < Formula
  desc "Validate, audit and investigate WebAssembly binaries"
  homepage "https://dylibso.com/products/modsurfer/"
  url "https://github.com/dylibso/modsurfer/archive/refs/tags/v0.0.10.tar.gz"
  sha256 "2f5defcfe8668d7323a83dab0b323282e2855a4171c1d0d4eacf5963aa3729b1"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7d561740c72ebcf3a01fea7db5ee11eca2486a607a20b94161b87af75717d8e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e519824fac34bcc80c508da8c5c2a1fd4f09aac1280681f9c26874ee29e4e40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d25c85d57efbf38fa29fbc83354de21d74379c9ebe208603afe68225acacb993"
    sha256 cellar: :any,                 arm64_linux:       "b944ffb5c1262c53a8b3e58055bb0d8bdae7bf70004991ff596f9bce025965c1"
    sha256 cellar: :any,                 x86_64_linux:      "03f6d8153200b7ef04060b88addd5a70c8adb8512b52b135349e94d7eb13149d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/modsurfer -V")

    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)

    system bin/"modsurfer", "generate", "-p", "sum.wasm", "-o", "mod.yaml"
    assert_path_exists testpath/"mod.yaml"
    system bin/"modsurfer", "validate", "-p", "sum.wasm", "-c", "mod.yaml"
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 8f3697f..8eeb1b1 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1661,11 +1661,11 @@ checksum = "dd8b5dd2ae5ed71462c540258bedcb51965123ad7e7ccf4b9a8cafaa4a63576d"
 
 [[package]]
 name = "openssl"
-version = "0.10.54"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "69b3f656a17a6cbc115b5c7a40c616947d213ba182135b014d6051b73ab6f019"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
- "bitflags 1.3.2",
+ "bitflags 2.4.1",
  "cfg-if",
  "foreign-types",
  "libc",
@@ -1693,9 +1693,9 @@ checksum = "ff011a302c396a5197692431fc1948019154afc178baf7d8e37367442a4601cf"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.88"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c2ce0f250f34a308dcfdbb351f511359857d4ed2134ba715a4eadd46e1ffd617"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
