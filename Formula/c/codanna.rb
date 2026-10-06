class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://docs.codanna.sh/"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "ea3cbe407e92395f670f990bd4be875685791e768a65eba1895dfd41f35b28b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "89b79cd16991f36a49f6aaa33c9016f9fcf07f6796f5593c3f256f48b88302dd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "429ec3a5a85220be5dc62468ecb72212e42fc4f18fbcc33109129fe0a5e20c69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "64077c214f60c4f56e71c73b825a6370ae8d05a1db1427eb5e5b028cd4037d22"
    sha256 cellar: :any,                 arm64_linux:       "b4d760a6d1f4dcdd40339fea3c53391fc5c32dbbaf93aa9e246479ab5059b669"
    sha256 cellar: :any,                 x86_64_linux:      "90f8405226ffd97adf821527f61170341d11834e9f57a3e0081e2107a53d61c8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "onnxruntime"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  patch :DATA

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["ORT_LIB_LOCATION"] = formula_opt_lib("onnxruntime")
    ENV["ORT_PREFER_DYNAMIC_LINK"] = "1"
    ENV.append_to_rustflags "-C link-args=-Wl,-rpath,#{rpath(target: formula_opt_lib("onnxruntime"))}"

    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end

__END__
diff --git a/Cargo.toml b/Cargo.toml
index 0000000..0000000 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -78 +78,2 @@
-fastembed = "=5.6.0"
+fastembed = { version = "=5.6.0", default-features = false, features = ["ort-download-binaries", "hf-hub", "image-models"] }
+ureq = { version = "2.12", default-features = false, features = ["tls"] }
diff --git a/Cargo.lock b/Cargo.lock
index 0000000..0000000 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -851,0 +852 @@
+ "ureq 2.12.1",
@@ -923,10 +923,0 @@
-
-[[package]]
-name = "core-foundation"
-version = "0.9.4"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "91e195e091a93c46f7102ec7818a2aa394e1e1771c3ab4825963fa03e45afb8f"
-dependencies = [
- "core-foundation-sys",
- "libc",
-]
@@ -1411,9 +1401,0 @@
-name = "encoding_rs"
-version = "0.8.35"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "75030f3c4f45dafd7586dd6780965a8c7e8e285a5ecb86713e63a79c5b2766f3"
-dependencies = [
- "cfg-if",
-]
-
-[[package]]
@@ -1942 +1923,0 @@
- "native-tls",
@@ -1944 +1924,0 @@
- "reqwest",
@@ -2090,16 +2069,0 @@
-name = "hyper-tls"
-version = "0.6.0"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "70206fc6890eaca9fde8a0bf71caa2ddfc9fe045ac9e5c70df101a7dbde866e0"
-dependencies = [
- "bytes",
- "http-body-util",
- "hyper",
- "hyper-util",
- "native-tls",
- "tokio",
- "tokio-native-tls",
- "tower-service",
-]
-
-[[package]]
@@ -2123 +2086,0 @@
- "system-configuration",
@@ -2127 +2089,0 @@
- "windows-registry",
@@ -3947 +3908,0 @@
- "encoding_rs",
@@ -3949,2 +3909,0 @@
- "futures-util",
- "h2",
@@ -3956 +3914,0 @@
- "hyper-tls",
@@ -3960,2 +3917,0 @@
- "mime",
- "native-tls",
@@ -3972 +3927,0 @@
- "tokio-native-tls",
@@ -3974 +3928,0 @@
- "tokio-util",
@@ -3981 +3934,0 @@
- "wasm-streams",
@@ -4229 +4182 @@
- "core-foundation 0.10.1",
+ "core-foundation",
@@ -4643,21 +4595,0 @@
-]
-
-[[package]]
-name = "system-configuration"
-version = "0.7.0"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a13f3d0daba03132c0aa9767f98351b3488edc2c100cda2d2ec2b04f3d8d3c8b"
-dependencies = [
- "bitflags 2.13.1",
- "core-foundation 0.9.4",
- "system-configuration-sys",
-]
-
-[[package]]
-name = "system-configuration-sys"
-version = "0.6.0"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8e1d1b10ced5ca923a1fcb8d03e96b8d3268065d724548c0211415ff6ac6bac4"
-dependencies = [
- "core-foundation-sys",
- "libc",
@@ -5050,10 +4981,0 @@
-name = "tokio-native-tls"
-version = "0.3.1"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "bbae76ab933c85776efabc971569dd6119c580d8f5d448769dec1764bf796ef2"
-dependencies = [
- "native-tls",
- "tokio",
-]
-
-[[package]]
@@ -5627 +5548,0 @@
- "native-tls",
@@ -5871,13 +5791,0 @@
-name = "wasm-streams"
-version = "0.4.2"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "15053d8d85c7eccdbefef60f06769760a563c7f0a9d6902a13d35c7800b0ad65"
-dependencies = [
- "futures-util",
- "js-sys",
- "wasm-bindgen",
- "wasm-bindgen-futures",
- "web-sys",
-]
-
-[[package]]
@@ -6060,11 +5967,0 @@
-]
-
-[[package]]
-name = "windows-registry"
-version = "0.6.1"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "02752bf7fbdcce7f2a27a742f798510f3e5ad88dbe84871e5168e2120c3d5720"
-dependencies = [
- "windows-link",
- "windows-result",
- "windows-strings",
