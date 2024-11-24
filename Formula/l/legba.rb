class Legba < Formula
  desc "Multiprotocol credentials bruteforcer/password sprayer and enumerator"
  homepage "https://github.com/evilsocket/legba"
  url "https://github.com/evilsocket/legba/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "9755ec21539ec31dfc6c314dde1416c9b2bc79199f5aceb937e84bafc445b208"
  license "AGPL-3.0-only"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "samba"

  # upstream patch ref, https://github.com/evilsocket/legba/pull/63
  patch :DATA

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/legba --version")

    output = shell_output("#{bin}/legba --list-plugins")
    assert_match "Samba password authentication", output
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 1793eeb..6495bc4 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -80,7 +80,7 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "e01ed3140b2f8d422c68afa1ed2e85d996ea619c988ac834d255db32138655cb"
 dependencies = [
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -194,9 +194,9 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "f591380e2e68490b5dfaf1dd1aa0ebe78d84ba7067078512b4ea6e4492d622b8"
 dependencies = [
  "actix-router",
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -402,7 +402,7 @@ dependencies = [
  "nom 7.1.3",
  "num-traits",
  "rusticata-macros 4.1.0",
- "thiserror",
+ "thiserror 1.0.62",
  "time 0.3.36",
 ]

@@ -412,9 +412,9 @@ version = "0.5.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "7378575ff571966e99a744addeff0bff98b8ada0dedf1956d59e634db95eaac1"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
  "synstructure 0.13.1",
 ]

@@ -424,9 +424,9 @@ version = "0.2.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "7b18050c2cd6fe86c3a76584ef5e0baf286d038cda203eb6223df2cc413565f7"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -470,7 +470,7 @@ dependencies = [
  "pin-utils",
  "self_cell",
  "stop-token",
- "thiserror",
+ "thiserror 1.0.62",
  "tokio",
 ]

@@ -481,7 +481,7 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "9343dc5acf07e79ff82d0c37899f079db3534d99f189a1837c8e549c99405bec"
 dependencies = [
  "native-tls",
- "thiserror",
+ "thiserror 1.0.62",
  "tokio",
  "url",
 ]
@@ -519,7 +519,7 @@ dependencies = [
  "log",
  "nom 7.1.3",
  "pin-project",
- "thiserror",
+ "thiserror 1.0.62",
  "tokio",
 ]

@@ -533,7 +533,7 @@ dependencies = [
  "russh",
  "russh-keys",
  "russh-sftp",
- "thiserror",
+ "thiserror 1.0.62",
  "tokio",
 ]

@@ -554,9 +554,9 @@ version = "0.3.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "16e62a023e7c117e27523144c5d2459f4397fcc3cab0085af8e2224f643a0193"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -565,9 +565,9 @@ version = "0.1.81"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "6e0c28dcc82d7c8ead5cb13beb15405b57b8546e93215673ff8ca0349a028107"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -977,9 +977,9 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "2bac35c6dafb060fd4d275d9a4ffae97917c13a6327903a8be2153cd964f7085"
 dependencies = [
  "heck 0.5.0",
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -1255,9 +1255,9 @@ version = "0.1.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "f46882e17999c6cc590af592290432be3bce0428cb0d5f8b6715e4dc7b383eb3"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -1278,7 +1278,7 @@ checksum = "859d65a907b6852c9361e3185c862aae7fafd2887876799fa55f5f99dc40d610"
 dependencies = [
  "fnv",
  "ident_case",
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
  "strsim 0.10.0",
  "syn 1.0.109",
@@ -1371,7 +1371,7 @@ version = "2.2.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "fcc3dd5e9e9c0b295d6e1e4d811fb6f157d5ffd784b8d202fc62eac8035a770b"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
  "syn 1.0.109",
 ]
@@ -1383,10 +1383,10 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "5f33878137e4dafd7fa914ad4e259e18a4e8e532b9617a2d0150262bf53abfce"
 dependencies = [
  "convert_case",
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
  "rustc_version 0.4.0",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -1446,9 +1446,9 @@ version = "0.2.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "97369cbbc041bc366949bc74d34658d6cda5621039731c6310521892a3a20ae0"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -1617,7 +1617,7 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "21cdad81446a7f7dc43f6a77409efeb9733d2fa65553efef6018ef257c959b73"
 dependencies = [
  "heck 0.4.1",
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
  "syn 1.0.109",
 ]
@@ -1629,9 +1629,9 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "5ffccbb6966c05b32ef8fbac435df276c4ae4d3dc55a8cd0eb9745e6c12f546a"
 dependencies = [
  "heck 0.4.1",
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -1717,7 +1717,7 @@ version = "0.1.8"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "aa4da3c766cd7a0db8242e326e9e4e081edd567072893ed320008189715366a4"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
  "syn 1.0.109",
  "synstructure 0.12.6",
@@ -1738,7 +1738,7 @@ dependencies = [
  "anyhow",
  "async-trait",
  "log",
- "thiserror",
+ "thiserror 1.0.62",
  "tokio",
  "tokio-stream",
 ]
@@ -1903,9 +1903,9 @@ version = "0.3.30"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "87750cf4b7a4c0625b1529e4c543c2182106e4dedc60a2a6455e00d212c489ac"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -2480,10 +2480,10 @@ version = "3.2.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "9efb9e65d4503df81c615dc33ff07042a9408ac7f26b45abee25566f7fbfd12c"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
  "regex",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -2521,7 +2521,7 @@ dependencies = [
  "native-tls",
  "nom 7.1.3",
  "percent-encoding",
- "thiserror",
+ "thiserror 1.0.62",
  "tokio",
  "tokio-native-tls",
  "tokio-stream",
@@ -2809,7 +2809,7 @@ dependencies = [
  "encoding",
  "futures",
  "regex",
- "thiserror",
+ "thiserror 1.0.62",
  "tokio",
  "tokio-util",
 ]
@@ -2877,7 +2877,7 @@ dependencies = [
  "stringprep",
  "strsim 0.10.0",
  "take_mut",
- "thiserror",
+ "thiserror 1.0.62",
  "tokio",
  "tokio-rustls",
  "tokio-util",
@@ -3126,7 +3126,7 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "ffa5a33ddddfee04c0283a7653987d634e880347e96b5b2ed64de07efb59db9d"
 dependencies = [
  "proc-macro-crate 0.1.5",
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
  "syn 1.0.109",
 ]
@@ -3138,9 +3138,9 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "96667db765a921f7b295ffee8b60472b686a51d4f21c2ee4ffdb94c7013b65a6"
 dependencies = [
  "proc-macro-crate 1.3.1",
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -3200,9 +3200,9 @@ version = "0.1.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "a948666b637a0f465e8564c73e89d4dde00d72d4d473cc972f390fc3dcee7d9c"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -3278,7 +3278,7 @@ dependencies = [
  "libc",
  "log",
  "paho-mqtt-sys",
- "thiserror",
+ "thiserror 1.0.62",
 ]

 [[package]]
@@ -3339,16 +3339,16 @@ checksum = "57c0d7b74b563b49d38dae00a0c37d4d6de9b432382b2892f0574ddcae73fd0a"

 [[package]]
 name = "pavao"
-version = "0.2.7"
+version = "0.2.8"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e3bc0f9e07a0ef53a1004f67e01bc2fbf877ea9835dce2947e27fc7ac77b44db"
+checksum = "6b774c6719bca86c3e98d6c643793cbd447f7c4e653ed85442a87c53cac879d5"
 dependencies = [
  "cfg_aliases 0.2.1",
  "lazy_static",
  "libc",
  "log",
  "pkg-config",
- "thiserror",
+ "thiserror 2.0.8",
 ]

 [[package]]
@@ -3400,9 +3400,9 @@ version = "1.1.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "2f38a4412a78282e09a2cf38d195ea5420d15ba0602cb375210efbc877243965"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -3518,9 +3518,9 @@ dependencies = [

 [[package]]
 name = "proc-macro2"
-version = "1.0.86"
+version = "1.0.92"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5e719e8df665df0d1c8fbfd238015744736151d4445ec0836b8e628aae103b77"
+checksum = "37d3544b3f2748c54e147655edb5025752e2303145b5aefb3c3ea2c78b973bb0"
 dependencies = [
  "unicode-ident",
 ]
@@ -3562,7 +3562,7 @@ version = "1.0.36"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "0fa76aaf39101c457836aec0ce2316dbdc3ab723cdda1c6bd4e6ad4208acaca7"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
 ]

 [[package]]
@@ -3860,7 +3860,7 @@ checksum = "bd283d9651eeda4b2a83a43c1c91b266c40fd76ecd39a50a8c630ae69dc72891"
 dependencies = [
  "getrandom 0.2.15",
  "libredox",
- "thiserror",
+ "thiserror 1.0.62",
 ]

 [[package]]
@@ -4033,7 +4033,7 @@ dependencies = [
  "sha1",
  "sha2",
  "subtle 2.6.1",
- "thiserror",
+ "thiserror 1.0.62",
  "tokio",
  "tokio-util",
 ]
@@ -4081,7 +4081,7 @@ dependencies = [
  "serde",
  "sha1",
  "sha2",
- "thiserror",
+ "thiserror 1.0.62",
  "tokio",
  "tokio-stream",
  "yasna 0.5.2",
@@ -4100,7 +4100,7 @@ dependencies = [
  "flurry",
  "log",
  "serde",
- "thiserror",
+ "thiserror 1.0.62",
  "tokio",
 ]

@@ -4284,7 +4284,7 @@ dependencies = [
  "socket2 0.5.7",
  "strum",
  "strum_macros",
- "thiserror",
+ "thiserror 1.0.62",
  "tokio",
  "tracing",
  "uuid",
@@ -4306,7 +4306,7 @@ dependencies = [
  "num_enum 0.6.1",
  "scylla-macros",
  "snap",
- "thiserror",
+ "thiserror 1.0.62",
  "tokio",
  "uuid",
 ]
@@ -4317,9 +4317,9 @@ version = "0.2.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "66bbac3874ee838894b5a82c5833c2b0b29d39ca5ad486d982ee434177b2cc57"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -4416,9 +4416,9 @@ version = "1.0.204"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "e0cd7e117be63d3c3678776753929474f3b04a43a080c744d6b0ae2a8c28e222"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -4462,7 +4462,7 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "e182d6ec6f05393cc0e5ed1bf81ad6db3a8feedf8ee515ecdd369809bcce8082"
 dependencies = [
  "darling",
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
  "syn 1.0.109",
 ]
@@ -4667,7 +4667,7 @@ dependencies = [
  "sha2",
  "smallvec",
  "sqlformat",
- "thiserror",
+ "thiserror 1.0.62",
  "tokio",
  "tokio-stream",
  "tracing",
@@ -4680,7 +4680,7 @@ version = "0.7.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "4ea40e2345eb2faa9e1e5e326db8c34711317d2b5e08d0d5741619048a803127"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
  "sqlx-core",
  "sqlx-macros-core",
@@ -4698,7 +4698,7 @@ dependencies = [
  "heck 0.4.1",
  "hex",
  "once_cell",
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
  "serde",
  "serde_json",
@@ -4750,7 +4750,7 @@ dependencies = [
  "smallvec",
  "sqlx-core",
  "stringprep",
- "thiserror",
+ "thiserror 1.0.62",
  "tracing",
  "whoami",
 ]
@@ -4788,7 +4788,7 @@ dependencies = [
  "smallvec",
  "sqlx-core",
  "stringprep",
- "thiserror",
+ "thiserror 1.0.62",
  "tracing",
  "whoami",
 ]
@@ -4879,7 +4879,7 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "5bb0dc7ee9c15cea6199cde9a127fa16a4c5819af85395457ad72d68edc85a38"
 dependencies = [
  "heck 0.3.3",
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
  "rustversion",
  "syn 1.0.109",
@@ -4914,18 +4914,18 @@ version = "1.0.109"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "72b64191b275b66ffe2469e8af2c1cfe3bafa67b529ead792a6d0160888b4237"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
  "unicode-ident",
 ]

 [[package]]
 name = "syn"
-version = "2.0.71"
+version = "2.0.90"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "b146dcf730474b4bcd16c311627b31ede9ab149045db4d6088b3becaea046462"
+checksum = "919d3b74a5dd0ccd15aeb8f93e7006bd9e14c295087c9896a110f490752bcf31"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
  "unicode-ident",
 ]
@@ -4936,7 +4936,7 @@ version = "0.12.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "f36bdaa60a83aca3921b5259d5400cbf5e90fc51931376a9bd4a0eb79aa7210f"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
  "syn 1.0.109",
  "unicode-xid 0.2.4",
@@ -4948,9 +4948,9 @@ version = "0.13.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "c8af7666ab7b6390ab78131fb5b0fce11d6b7a6951602017c35fa82800708971"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -4992,7 +4992,16 @@ version = "1.0.62"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "f2675633b1499176c2dff06b0856a27976a8f9d436737b4cf4f312d4d91d8bbb"
 dependencies = [
- "thiserror-impl",
+ "thiserror-impl 1.0.62",
+]
+
+[[package]]
+name = "thiserror"
+version = "2.0.8"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "08f5383f3e0071702bf93ab5ee99b52d26936be9dedd9413067cbdcddcb6141a"
+dependencies = [
+ "thiserror-impl 2.0.8",
 ]

 [[package]]
@@ -5001,9 +5010,20 @@ version = "1.0.62"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "d20468752b09f49e909e55a5d338caa8bedf615594e9d80bc4c565d30faf798c"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
+ "quote 1.0.36",
+ "syn 2.0.90",
+]
+
+[[package]]
+name = "thiserror-impl"
+version = "2.0.8"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "f2f357fcec90b3caef6623a099691be676d033b40a058ac95d2a6ade6fa0c943"
+dependencies = [
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -5097,9 +5117,9 @@ version = "2.3.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "5f5ae998a069d4b5aba8ee9dad856af7d520c3699e6159b185c2acd48155d39a"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -5130,7 +5150,7 @@ checksum = "51165dfa029d2a65969413a6cc96f354b86b464498702f174a4efa13608fd8c0"
 dependencies = [
  "either",
  "futures-util",
- "thiserror",
+ "thiserror 1.0.62",
  "tokio",
 ]

@@ -5222,9 +5242,9 @@ version = "0.1.27"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "34704c8d6ebcbc939824180af020566b01a7c01f80641264eba0999f6c2b6be7"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
@@ -5255,7 +5275,7 @@ dependencies = [
  "log",
  "rand 0.8.5",
  "smallvec",
- "thiserror",
+ "thiserror 1.0.62",
  "tinyvec",
  "tokio",
  "url",
@@ -5279,7 +5299,7 @@ dependencies = [
  "once_cell",
  "rand 0.8.5",
  "smallvec",
- "thiserror",
+ "thiserror 1.0.62",
  "tinyvec",
  "tokio",
  "tracing",
@@ -5301,7 +5321,7 @@ dependencies = [
  "parking_lot",
  "resolv-conf",
  "smallvec",
- "thiserror",
+ "thiserror 1.0.62",
  "tokio",
  "trust-dns-proto 0.21.2",
 ]
@@ -5321,7 +5341,7 @@ dependencies = [
  "rand 0.8.5",
  "resolv-conf",
  "smallvec",
- "thiserror",
+ "thiserror 1.0.62",
  "tokio",
  "tracing",
  "trust-dns-proto 0.23.2",
@@ -5349,7 +5369,7 @@ version = "0.10.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "89851716b67b937e393b3daa8423e67ddfc4bbbf1654bcf05488e95e0828db0c"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
  "syn 1.0.109",
 ]
@@ -5494,7 +5514,7 @@ dependencies = [
  "async_io_stream",
  "flate2",
  "futures",
- "thiserror",
+ "thiserror 1.0.62",
  "tokio",
  "tokio-stream",
  "tokio-util",
@@ -5518,7 +5538,7 @@ version = "0.1.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "2e369bee1b05d510a7b4ed645f5faa90619e05437111783ea5848f28d97d3c2e"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
 ]

@@ -5574,9 +5594,9 @@ dependencies = [
  "bumpalo",
  "log",
  "once_cell",
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
  "wasm-bindgen-shared",
 ]

@@ -5608,9 +5628,9 @@ version = "0.2.92"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "e94f17b526d0a461a191c78ea52bbce64071ed5c04c9ffe424dcb38f74171bb7"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
  "wasm-bindgen-backend",
  "wasm-bindgen-shared",
 ]
@@ -5906,7 +5926,7 @@ dependencies = [
  "nom 7.1.3",
  "oid-registry",
  "rusticata-macros 4.1.0",
- "thiserror",
+ "thiserror 1.0.62",
  "time 0.3.36",
 ]

@@ -5941,9 +5961,9 @@ version = "0.7.35"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "fa4f8080344d4671fb4e831a13ad1e68092748387dfc4f55e356242fae12ce3e"
 dependencies = [
- "proc-macro2 1.0.86",
+ "proc-macro2 1.0.92",
  "quote 1.0.36",
- "syn 2.0.71",
+ "syn 2.0.90",
 ]

 [[package]]
diff --git a/Cargo.toml b/Cargo.toml
index adab05b..50db70d 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -81,7 +81,7 @@ rdp-rs = { version = "0.1.0", optional = true }
 scylla = { version = "0.10.1", optional = true }
 paho-mqtt = { version = "0.12.3", optional = true }
 csv = "1.3.0"
-pavao = { version = "0.2.7", optional = true }
+pavao = { version = "0.2.8", optional = true }
 fast-socks5 = { version = "0.9.2", optional = true }
 shell-words = "1.1.0"
 serde_yaml = "0.9.30"
