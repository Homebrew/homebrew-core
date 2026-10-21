class ProtonPassCli < Formula
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"
  url "https://github.com/protonpass/pass-cli/archive/refs/tags/2.5.0.tar.gz"
  sha256 "ea6104210c3809f42dc52d24748e07d07a0f70bcd4b443c314dcdb79a2f5fe80"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a4931d2ddfd8e10bcd4dab8c88ea8ef82c975059b08f4ab1fd5927fb60b0843e"
    sha256 cellar: :any, arm64_tahoe:       "4a4f15c6658c00dc05b02eeed347075557df51494bdaf6d76e5c708a74ea4853"
    sha256 cellar: :any, arm64_sequoia:     "3ea5dacf92b4aca19ca7a014a5b1e999ec952ec73d1ea5504986831cd580fd96"
    sha256 cellar: :any, arm64_linux:       "dc633f5a38ca787b91c12d8f319586f06a1c3af6a5a9b2177a952a334f15d679"
    sha256 cellar: :any, x86_64_linux:      "4563d67c130399852bcb1ff90d212d673a769c9fb181ce224f3791a9bfe8976f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  # Upstream does not currently accept external contributions.
  # Regenerate lockfile
  patch :DATA

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "pass-cli")
    generate_completions_from_executable(bin/"pass-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pass-cli --version")
    assert_match "Successful", shell_output("#{bin}/pass-cli logout --force")

    # Most operations require an authenticated session or keyring access.
    ENV["PROTON_PASS_KEY_PROVIDER"] = "fs"
    output_log = testpath/"output.log"
    pid = spawn bin/"pass-cli", "login", [:out, :err] => output_log.to_s
    sleep 5
    assert_match "Waiting for authentication to complete", output_log.read
  ensure
    if pid
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 4e779ff..0188d84 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -20,7 +20,7 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "1973cfbc1a2daf9cf550e74e1f088c28e7f7d8c1e1418fb6c9dc5184b7e84c99"
 dependencies = [
  "crypto-common 0.2.2",
- "inout 0.2.2",
+ "inout 0.2.5",
 ]
 
 [[package]]
@@ -222,7 +222,7 @@ dependencies = [
  "rustc-hash",
  "serde",
  "serde_derive",
- "syn 3.0.6",
+ "syn 3.0.9",
 ]
 
 [[package]]
@@ -386,13 +386,13 @@ dependencies = [
 
 [[package]]
 name = "async-recursion"
-version = "1.1.1"
+version = "1.2.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "3b43422f69d8ff38f95f1b2bb76517c91589a924d1559a0e935d7c8ce0274c11"
+checksum = "4f8abc12baad266b1c8cec146854c195b5864b4221d4b2ca7296a7ae82d9e451"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.119",
+ "syn 3.0.9",
 ]
 
 [[package]]
@@ -427,7 +427,7 @@ checksum = "82f6aeea286b8eb4dd3431a1be1b59d290ace00f5bfd8e2a159bc2a05e2c1667"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 3.0.6",
+ "syn 3.0.9",
 ]
 
 [[package]]
@@ -571,7 +571,7 @@ checksum = "144e573728da132683b9488acd528274c790e07fc06ff81ee29f9d8f8b1041e0"
 dependencies = [
  "blowfish 0.10.0",
  "pbkdf2 0.13.0",
- "sha2 0.11.0",
+ "sha2 0.11.1",
 ]
 
 [[package]]
@@ -871,9 +871,9 @@ dependencies = [
 
 [[package]]
 name = "cc"
-version = "1.5.1"
+version = "1.9.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f360145194ee8e21db5ee7f3fcd4fe52210864c75c985dae33218202c8bbe040"
+checksum = "877bf67ac8e52449eb2f9e98a344ea163beb70dd1f9eebe3cc5357dcfeaee4df"
 dependencies = [
  "find-msvc-tools",
  "jobserver",
@@ -992,7 +992,7 @@ checksum = "e8cf2a2c93cd704877c0858356ed03480ff301ee950b43f1cbe4573b088bfa6c"
 dependencies = [
  "block-buffer 0.12.1",
  "crypto-common 0.2.2",
- "inout 0.2.2",
+ "inout 0.2.5",
  "zeroize",
 ]
 
@@ -1047,7 +1047,7 @@ dependencies = [
  "heck",
  "proc-macro2",
  "quote",
- "syn 3.0.6",
+ "syn 3.0.9",
 ]
 
 [[package]]
@@ -1081,9 +1081,9 @@ checksum = "1d07550c9036bf2ae0c684c4297d503f838287c83c53686d05370d0e139ae570"
 
 [[package]]
 name = "combine"
-version = "4.6.8"
+version = "4.6.9"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "cfc320937d09e6de266b31b9afb480f197d7a861be86be7cb2ea7e5d1bfffc5e"
+checksum = "4356eba6976435498d05a311ee9fc486da3bc81c200d3f0d7dd9703b41913f92"
 dependencies = [
  "bytes",
  "memchr",
@@ -1114,16 +1114,6 @@ dependencies = [
  "crossbeam-utils",
 ]
 
-[[package]]
-name = "console_error_panic_hook"
-version = "0.1.7"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a06aeb73f470f66dcdbf7223caeebb85984942f22f1adb2a088cf9668146bbbc"
-dependencies = [
- "cfg-if",
- "wasm-bindgen",
-]
-
 [[package]]
 name = "const-oid"
 version = "0.9.6"
@@ -1378,9 +1368,9 @@ dependencies = [
 
 [[package]]
 name = "ctutils"
-version = "0.4.2"
+version = "0.4.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "7d5515a3834141de9eafb9717ad39eea8247b5674e6066c404e8c4b365d2a29e"
+checksum = "03bb0e1cc970d482d121d9a1744999169b69a07470b3d644a7894e53fcaf4574"
 dependencies = [
  "cmov",
  "subtle",
@@ -1491,7 +1481,7 @@ dependencies = [
  "proc-macro2",
  "quote",
  "strsim",
- "syn 3.0.6",
+ "syn 3.0.9",
 ]
 
 [[package]]
@@ -1513,7 +1503,7 @@ checksum = "2ac7135c3ef02b2f7833bbeb1be5ba7f966dcde8a87c6b87f65a778d71a02785"
 dependencies = [
  "darling_core 0.24.1",
  "quote",
- "syn 3.0.6",
+ "syn 3.0.9",
 ]
 
 [[package]]
@@ -1555,9 +1545,9 @@ checksum = "ac6b926516df9c60bfa16e107b21086399f8285a44ca9711344b9e553c5146e2"
 
 [[package]]
 name = "defmt"
-version = "1.1.1"
+version = "1.2.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e2953bfe4f93bbd20cc71198842756f77d161884c99ebbabc41d80231ded88d1"
+checksum = "e4a0795ac740cb54d7b3775c9c17345f6aaecf884c01733b39d6017738e0e3e1"
 dependencies = [
  "bitflags 1.3.2",
  "defmt-macros",
@@ -1565,21 +1555,21 @@ dependencies = [
 
 [[package]]
 name = "defmt-macros"
-version = "1.1.1"
+version = "1.2.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "bad9c72e7ca2137e0dc3813245a0d282fd6daad32fd800af018306a9169b5fe8"
+checksum = "840bb056bd99c495c9188198a258ab787c79f306d864db3e6e8451442d6d8366"
 dependencies = [
  "defmt-parser",
  "proc-macro2",
  "quote",
- "syn 2.0.119",
+ "syn 3.0.9",
 ]
 
 [[package]]
 name = "defmt-parser"
-version = "1.0.0"
+version = "1.1.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "10d60334b3b2e7c9d91ef8150abfb6fa4c1c39ebbcf4a81c2e346aad939fee3e"
+checksum = "71958f69fb2de856c5dd51ac9377e986ca1aa5919f931bf5395a807277f889a0"
 dependencies = [
  "thiserror 2.0.21",
 ]
@@ -1622,9 +1612,9 @@ dependencies = [
 
 [[package]]
 name = "deranged"
-version = "0.5.8"
+version = "0.5.9"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "7cd812cc2bc1d69d4764bd80df88b4317eaef9e773c75226407d9bc0876b211c"
+checksum = "9e9de72ce2ad1f90dc62fa25f0f430ef85eb4b0d8fa0be4f30373bc40a21d28e"
 dependencies = [
  "serde_core",
 ]
@@ -1793,7 +1783,7 @@ checksum = "c6232dd377dcc64799954cbd3a9bb882e9cdc1308ccd87b1c098f1fb2eaf82a8"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 3.0.6",
+ "syn 3.0.9",
 ]
 
 [[package]]
@@ -1871,7 +1861,7 @@ dependencies = [
  "elliptic-curve 0.14.1",
  "rfc6979 0.6.0",
  "signature 3.0.0",
- "spki 0.8.0",
+ "spki 0.8.1",
  "zeroize",
 ]
 
@@ -1920,7 +1910,7 @@ dependencies = [
  "ed25519 3.0.0",
  "rand_core 0.10.1",
  "serde",
- "sha2 0.11.0",
+ "sha2 0.11.1",
  "signature 3.0.0",
  "subtle",
  "zeroize",
@@ -1928,9 +1918,9 @@ dependencies = [
 
 [[package]]
 name = "either"
-version = "1.18.0"
+version = "1.19.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "252afb9ae5eaa683babdc6a068b3f5726eb19e05070c731f9b2a23a7c3e8ed34"
+checksum = "0e9c71c2167ca323c882b99918929403426e2373ea17242ff5653e0d5e1058be"
 
 [[package]]
 name = "elliptic-curve"
@@ -2030,9 +2020,9 @@ dependencies = [
 
 [[package]]
 name = "equivalent"
-version = "1.0.2"
+version = "1.0.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "877a4ace8713b0bcf2a4e7eec82529c029f1d0619886d18145fea96c3ffe5c0f"
+checksum = "00d174d5400e5e8fd687ad1049e2f578285fa914201b1af7e8b112a4546bd826"
 
 [[package]]
 name = "errno"
@@ -2123,9 +2113,9 @@ checksum = "55d9ccda37e95b4f0978a3074b4a9939979103a7256459cfb449c9c84d1adf23"
 
 [[package]]
 name = "find-msvc-tools"
-version = "0.1.14"
+version = "0.1.15"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "aedcfb3409746eddb02b9e19ebda1c3394f759a152e48ee875a0844d1b955484"
+checksum = "1c66915cc5391097de7a2b0b972e8505aa33c0df401fd3a6811dbdb32881ba48"
 
 [[package]]
 name = "flate2"
@@ -2185,9 +2175,9 @@ dependencies = [
 
 [[package]]
 name = "fs-err"
-version = "3.3.1"
+version = "3.3.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "b91aa448ca50d7e79433bdf3ee8d99215430d2ec02ade5aefab2a073a1822e8a"
+checksum = "b5c95b673b8f6f7235229ae11c5642d81b04c2e64c1e2fb417bc0cf73ca45f29"
 dependencies = [
  "autocfg",
 ]
@@ -2267,7 +2257,7 @@ checksum = "9fb9654ba8355388abeb8dcb4fc62f511300867002afc858860463bdd9fe0c44"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 3.0.6",
+ "syn 3.0.9",
 ]
 
 [[package]]
@@ -2426,9 +2416,9 @@ dependencies = [
 
 [[package]]
 name = "gopenpgp-sys"
-version = "0.3.8"
+version = "0.3.9"
 source = "sparse+https://rust-registry.proton.me/index/"
-checksum = "7a1e94b9ed82cf988223e08e7cccae165a8676048ff97b94a9a7e7330a9d65cb"
+checksum = "ff5bbad786236652fa1dc40c88d4bffc63befacd43215cf342535aecfa9062dc"
 dependencies = [
  "base64 0.22.1",
  "bindgen",
@@ -2460,9 +2450,9 @@ dependencies = [
 
 [[package]]
 name = "h2"
-version = "0.4.19"
+version = "0.4.20"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "ef8e5e5a340588f4452631496976cf8636d4a7ecf600239fdc27615d2530bc16"
+checksum = "7d29020232d6aa3fb1daca64c1127cf662cf97f254ae16c18c05b8ab635fc118"
 dependencies = [
  "atomic-waker",
  "bytes",
@@ -2485,7 +2475,7 @@ checksum = "6ea2d84b969582b4b1864a92dc5d27cd2b77b622a8d79306834f1be5ba20d84b"
 dependencies = [
  "cfg-if",
  "crunchy",
- "zerocopy 0.8.59",
+ "zerocopy 0.8.63",
 ]
 
 [[package]]
@@ -2720,9 +2710,9 @@ dependencies = [
 
 [[package]]
 name = "hyper"
-version = "1.11.1"
+version = "1.12.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "27b501faa50e7a26c3d3560ca625132f4078a17771f4810baf70475ae48cbe43"
+checksum = "2c3e324da4c95177d6291d4c8730197c0d1822f8a9766814a4a44fa5ab797c9c"
 dependencies = [
  "atomic-waker",
  "bytes",
@@ -2988,9 +2978,9 @@ dependencies = [
 
 [[package]]
 name = "inout"
-version = "0.2.2"
+version = "0.2.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "4250ce6452e92010fdf7268ccc5d14faa80bb12fc741938534c58f16804e03c7"
+checksum = "3b5cf4372d022092674a83b8febf5865f7a573cc0c5baec5e49c879b6a20978f"
 dependencies = [
  "block-padding 0.4.2",
  "hybrid-array 0.4.15",
@@ -2998,9 +2988,9 @@ dependencies = [
 
 [[package]]
 name = "interprocess"
-version = "2.4.4"
+version = "2.4.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "6cb02ffbf25e8ef0f4a95bff054eef75f6d1bf16919474cf2caa63b21997478a"
+checksum = "7529951166d4dd4d2a6b9f0bb97919b810623f75eeb76e81ee9e6644886cae37"
 dependencies = [
  "doctest-file",
  "libc",
@@ -3066,9 +3056,9 @@ checksum = "8f42a60cbdf9a97f5d2305f08a87dc4e09308d1276d28c869c684d7777685682"
 
 [[package]]
 name = "jiff"
-version = "0.2.37"
+version = "0.2.38"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "0ab1baf72f08796de0260609515130699b890ac25f30e610ad894bc5856cafdb"
+checksum = "b2b005715dcbeb0089a3c0dab99f2ff1cc3b2525323552703d648585d342a383"
 dependencies = [
  "defmt",
  "jiff-core",
@@ -3093,9 +3083,9 @@ dependencies = [
 
 [[package]]
 name = "jiff-static"
-version = "0.2.37"
+version = "0.2.38"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "378268a1116ad67ae6228701118ac9f491d78fda38a40a1f1a9e1348de6f7212"
+checksum = "2cc9817253cf7c7ee4684451bd327e88d6f3658014e54a29198625590650695c"
 dependencies = [
  "jiff-core",
  "proc-macro2",
@@ -3105,9 +3095,9 @@ dependencies = [
 
 [[package]]
 name = "jiff-tzdb"
-version = "0.1.8"
+version = "0.1.9"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "142bd39932ad231f10513df9ab62661fead8719872150b7ad02a2df79f4e141e"
+checksum = "fa8377070c6bae868759445e5a77f66d84f0b72f3a054bfb00e6d038b8282da7"
 
 [[package]]
 name = "jiff-tzdb-platform"
@@ -3233,18 +3223,18 @@ dependencies = [
 
 [[package]]
 name = "keyring-core"
-version = "1.0.0"
+version = "1.0.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "fb1e621458ca9c51aa110bd0339d4751a056b9576bf1253aee1aa560dda0fc9d"
+checksum = "29fbf4b551298c67925f38cf341a1ada797a75f1837bdf8ae1fc8e2ebc6efb59"
 dependencies = [
  "log",
 ]
 
 [[package]]
 name = "lazy_static"
-version = "1.5.0"
+version = "1.5.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "bbd2bcb4c963f2ddae06a2efc7e9f3591312473c50c6685e1f298068316e66fe"
+checksum = "20870f649af7073d53e38067b2a84312175d56ea15217e1b15bc83506ec50afb"
 dependencies = [
  "spin 0.9.9",
 ]
@@ -3323,9 +3313,9 @@ checksum = "34b357333733e8260735ba5894eb928c02ecc69c78715f01a8019e7fa7f2db4c"
 
 [[package]]
 name = "libc"
-version = "0.2.189"
+version = "0.2.191"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "3eaf3ede3fee6db1a4c2ee091bf8a8b4dccdc6d17f656fb07896ee72867612f2"
+checksum = "65cd87c9a6d60536580b316ad985726104730a5151c99845f2490428ef91240a"
 
 [[package]]
 name = "libloading"
@@ -3404,9 +3394,9 @@ checksum = "47d9d19d1d6efa0109d2f65ff4c85cddd50bd572e5a00127ab10987290bcefae"
 
 [[package]]
 name = "litrs"
-version = "1.0.0"
+version = "1.0.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "11d3d7f243d5c5a8b9bb5d6dd2b1602c0cb0b9db1621bafc7ed66e35ff9fe092"
+checksum = "4744e383959f0db86ede514b809b1c53251889093803c05267acc7d4e7030d70"
 
 [[package]]
 name = "lock_api"
@@ -3431,9 +3421,9 @@ checksum = "4050469837a6ff301cd14c1f8f24f88549e6d548f24f64e2148eb0f72cebc51f"
 
 [[package]]
 name = "luhn"
-version = "1.0.1"
+version = "1.0.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "4d10b831402a3b10e018c8bc7f0ec3344a67d0725919cbaf393accb9baf8700b"
+checksum = "01ba64f60de40bd13cfbc2c4be4f11cb9a72ecdc1073dbb3ab144991b14ac6ed"
 dependencies = [
  "digits_iterator",
 ]
@@ -3444,7 +3434,7 @@ version = "0.22.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "7277c9742229dc25243236d578b6471a798c554512c6f6a04365ec2e87c2a3bb"
 dependencies = [
- "sha2 0.11.0",
+ "sha2 0.11.1",
 ]
 
 [[package]]
@@ -3502,9 +3492,9 @@ checksum = "68354c5c6bd36d73ff3feceb05efa59b6acb7626617f4962be322a825e61f79a"
 
 [[package]]
 name = "mio"
-version = "1.2.3"
+version = "1.2.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "4b18443e9c262bfe8fa82f51666e2642c53393f7e5c27b3e1aeab922cff5b9d8"
+checksum = "1788edb87fdc09c7e26304471e2f5be8cdefb1b6930d6e3985fc02ff53bf86ee"
 dependencies = [
  "libc",
  "wasi",
@@ -3919,9 +3909,9 @@ dependencies = [
 
 [[package]]
 name = "objc2"
-version = "0.6.4"
+version = "0.6.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "3a12a8ed07aefc768292f076dc3ac8c48f3781c8f2d5851dd3d98950e8c5a89f"
+checksum = "08849bbd4767dfae9457696856ae1c84fe4e0281bbe4a7abff2d0e06fb7981f8"
 dependencies = [
  "objc2-encode",
 ]
@@ -4118,7 +4108,7 @@ dependencies = [
  "elliptic-curve 0.14.1",
  "primefield",
  "primeorder 0.14.0",
- "sha2 0.11.0",
+ "sha2 0.11.1",
 ]
 
 [[package]]
@@ -4144,7 +4134,7 @@ dependencies = [
  "fiat-crypto 0.3.0",
  "primefield",
  "primeorder 0.14.0",
- "sha2 0.11.0",
+ "sha2 0.11.1",
 ]
 
 [[package]]
@@ -4172,7 +4162,7 @@ dependencies = [
  "elliptic-curve 0.14.1",
  "primefield",
  "primeorder 0.14.0",
- "sha2 0.11.0",
+ "sha2 0.11.1",
 ]
 
 [[package]]
@@ -4345,47 +4335,6 @@ dependencies = [
  "tokio",
 ]
 
-[[package]]
-name = "pass-mobile-sdk"
-version = "2.5.0"
-dependencies = [
- "anyhow",
- "async-trait",
- "pass",
- "serde",
- "serde_json",
- "tracing",
- "tracing-subscriber",
- "uniffi",
-]
-
-[[package]]
-name = "pass-uniffi-bindgen"
-version = "2.5.0"
-dependencies = [
- "uniffi",
-]
-
-[[package]]
-name = "pass-web-sdk"
-version = "2.5.0"
-dependencies = [
- "anyhow",
- "async-trait",
- "console_error_panic_hook",
- "js-sys",
- "pass",
- "send_wrapper",
- "serde",
- "serde-wasm-bindgen",
- "time",
- "tracing",
- "tracing-subscriber",
- "tsify",
- "wasm-bindgen",
- "wasm-bindgen-futures",
-]
-
 [[package]]
 name = "passkey"
 version = "0.5.0"
@@ -4440,7 +4389,7 @@ dependencies = [
  "ml-dsa 0.1.1",
  "p256 0.14.0",
  "rand 0.10.3",
- "sha2 0.11.0",
+ "sha2 0.11.1",
  "signature 3.0.0",
  "zeroize",
 ]
@@ -4542,19 +4491,21 @@ checksum = "9b4f627cb1b25917193a259e49bdad08f671f8d9708acfd5fe0a8c1455d87220"
 
 [[package]]
 name = "pest"
-version = "2.9.2"
+version = "2.9.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "45d3aca230fad2e6f6317ca0a72724338c4960cb97168a85cdee66df4a9a21a8"
+checksum = "fd47a460a9cbc3b3429c7e22bf0d76653e779319bae45a499ca010c9a990bb23"
 dependencies = [
  "memchr",
+ "psm",
+ "stacker",
  "ucd-trie",
 ]
 
 [[package]]
 name = "pest_derive"
-version = "2.9.2"
+version = "2.9.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "284b60557f2c4a2e72ad3f2d34d42685a2fa4a6a61d0d2a10c0ae2a5e916c2cf"
+checksum = "203e46697708f7519ab1608393cf89239cafb46b8e6d08a8ffe359359b11ef44"
 dependencies = [
  "pest",
  "pest_generator",
@@ -4562,31 +4513,31 @@ dependencies = [
 
 [[package]]
 name = "pest_generator"
-version = "2.9.2"
+version = "2.9.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1d9d1f08a115309ee99268cf85e5228e0e56aa9caf8841ec12866b6be07c3109"
+checksum = "e84ae6340a458d3d6cfc73cf328cf3cfe90b2484cd0de25eb66aa954615ed4d5"
 dependencies = [
  "pest",
  "pest_meta",
  "proc-macro2",
  "quote",
- "syn 2.0.119",
+ "syn 3.0.9",
 ]
 
 [[package]]
 name = "pest_meta"
-version = "2.9.2"
+version = "2.9.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "ed93ba1a9ffcca32130a5188701c81c0c49cf00d4b7c5007d5148951d743adcb"
+checksum = "b57f92f32b3dbce6598fd8f5cdf1f06a6072570b8103fa21728fa9036923e710"
 dependencies = [
  "pest",
 ]
 
 [[package]]
 name = "pgp"
-version = "0.20.0"
+version = "0.21.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1cfa4743b28656065ff4c0ba09e46b357a65e8c00fc2341e89084b82f87cbdf1"
+checksum = "ae70f4d9325a391db30d115d6191a7bb67cec856aa0bba131290f0c4e09a532a"
 dependencies = [
  "aead 0.5.2",
  "aes 0.8.4",
@@ -4732,7 +4683,7 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "451913da69c775a56034ea8d9003d27ee8948e12443eae7c038ba100a4f21cb7"
 dependencies = [
  "der 0.8.2",
- "spki 0.8.0",
+ "spki 0.8.1",
 ]
 
 [[package]]
@@ -4833,15 +4784,15 @@ dependencies = [
 
 [[package]]
 name = "powerfmt"
-version = "0.2.0"
+version = "0.2.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "439ee305def115ba05938db6eb1644ff94165c5ab5e9420d1c1bcedbba909391"
+checksum = "4a6394b9e965e73d0a289ee54f589087e2c676aedf60885baf52c76b771e4958"
 
 [[package]]
 name = "ppmd-rust"
-version = "1.5.0"
+version = "1.5.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "196a7c80b9a7652aba7cc070827516c2abe4ccdf53d128e1944003cf5726cff1"
+checksum = "494b4379484fc92217cc7d9e3a532375b1d01a61889ec8333025dc3b0377af56"
 
 [[package]]
 name = "ppv-lite86"
@@ -4849,7 +4800,7 @@ version = "0.2.21"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "85eae3c4ed2f50dcfe72643da4befc30deadb458a9b590d720cde2f2b1e97da9"
 dependencies = [
- "zerocopy 0.8.59",
+ "zerocopy 0.8.63",
 ]
 
 [[package]]
@@ -4969,9 +4920,9 @@ dependencies = [
 
 [[package]]
 name = "protoc-bin-vendored"
-version = "3.2.0"
+version = "3.3.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d1c381df33c98266b5f08186583660090a4ffa0889e76c7e9a5e175f645a67fa"
+checksum = "8760a25b6ff9c620324822737e468478fa092234190d2e449760344354896ed9"
 dependencies = [
  "protoc-bin-vendored-linux-aarch_64",
  "protoc-bin-vendored-linux-ppcle_64",
@@ -4985,57 +4936,57 @@ dependencies = [
 
 [[package]]
 name = "protoc-bin-vendored-linux-aarch_64"
-version = "3.2.0"
+version = "3.3.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c350df4d49b5b9e3ca79f7e646fde2377b199e13cfa87320308397e1f37e1a4c"
+checksum = "73fa2624782ca04cd44f51554566717377acd240e4c0016d757dd74fccc9324f"
 
 [[package]]
 name = "protoc-bin-vendored-linux-ppcle_64"
-version = "3.2.0"
+version = "3.3.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a55a63e6c7244f19b5c6393f025017eb5d793fd5467823a099740a7a4222440c"
+checksum = "e2417e9817fa237dab803ad4dda7357a111656e242959cc6b8f9a1a583367d42"
 
 [[package]]
 name = "protoc-bin-vendored-linux-s390_64"
-version = "3.2.0"
+version = "3.3.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1dba5565db4288e935d5330a07c264a4ee8e4a5b4a4e6f4e83fad824cc32f3b0"
+checksum = "4d189c34636356a46a7ed3188233dc8a88c431278cc54d4a19b096a2d270e985"
 
 [[package]]
 name = "protoc-bin-vendored-linux-x86_32"
-version = "3.2.0"
+version = "3.3.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8854774b24ee28b7868cd71dccaae8e02a2365e67a4a87a6cd11ee6cdbdf9cf5"
+checksum = "171e39f1e846e5f322ced1ac3b8d4cd3a3833ca24b6e5d58b3632574fe6204fa"
 
 [[package]]
 name = "protoc-bin-vendored-linux-x86_64"
-version = "3.2.0"
+version = "3.3.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "b38b07546580df720fa464ce124c4b03630a6fb83e05c336fea2a241df7e5d78"
+checksum = "873cdcc097593432086661aa432b8078f1cd87bfb02847c332e98ae2c119e966"
 
 [[package]]
 name = "protoc-bin-vendored-macos-aarch_64"
-version = "3.2.0"
+version = "3.3.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "89278a9926ce312e51f1d999fee8825d324d603213344a9a706daa009f1d8092"
+checksum = "eeb72df001783b8297847fe8f5f874ee400fd742c843d60583e8c23d96977c7f"
 
 [[package]]
 name = "protoc-bin-vendored-macos-x86_64"
-version = "3.2.0"
+version = "3.3.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "81745feda7ccfb9471d7a4de888f0652e806d5795b61480605d4943176299756"
+checksum = "b04652167eca899dda05f32f5481adeaf25c623a98ce2fc146a001cc59a2add7"
 
 [[package]]
 name = "protoc-bin-vendored-win32"
-version = "3.2.0"
+version = "3.3.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "95067976aca6421a523e491fce939a3e65249bac4b977adee0ee9771568e8aa3"
+checksum = "263a3f48f01e7309e857138bd47f785585b4a005e8e56c6d2824ce91195999c3"
 
 [[package]]
 name = "proton-crypto"
-version = "0.14.0"
+version = "0.14.1"
 source = "sparse+https://rust-registry.proton.me/index/"
-checksum = "df1ce2629e8f7278cf681edb2c92179e68d1c44ce6d37eef61cfb01886ddf058"
+checksum = "ab3ad02301b100460d65d3b457fe6ef1a77e579c0ca832515341a25b8efd62e0"
 dependencies = [
  "gopenpgp-sys",
  "hex",
@@ -5051,9 +5002,9 @@ dependencies = [
 
 [[package]]
 name = "proton-crypto-account"
-version = "0.20.0"
+version = "0.20.1"
 source = "sparse+https://rust-registry.proton.me/index/"
-checksum = "0125930e771b27303fa6cdf862cd0b85b5c345ed897eabce9794b0013ba95cfc"
+checksum = "55f42b79f1718ecad3d60247b4c3f2f471b2237b6c8c5db182c522e137cabbd4"
 dependencies = [
  "base64 0.22.1",
  "derive_more 2.1.1",
@@ -5071,9 +5022,9 @@ dependencies = [
 
 [[package]]
 name = "proton-os-interface"
-version = "0.3.3"
+version = "0.3.5"
 source = "sparse+https://rust-registry.proton.me/index/"
-checksum = "255a294a047ca5d8660b73c22a9b4daf6045774947dc1c6445ab2c0a4a74e14f"
+checksum = "2d072e412deeb21cb2d6f98a497989227b34fd8ac7900de85522d3cf933b16ed"
 dependencies = [
  "derive_more 1.0.0",
  "futures",
@@ -5109,7 +5060,7 @@ dependencies = [
  "rmp-serde",
  "serde",
  "serde_json",
- "sha2 0.11.0",
+ "sha2 0.11.1",
  "smallvec",
  "ssh-key 0.7.0-rc.11",
  "tsify",
@@ -5123,7 +5074,7 @@ version = "2.1.1"
 source = "git+https://github.com/protonpass/proton-pass-common.git?tag=2.1.1#25b673b98ed84982e74a1fbcdf036ebd7957950f"
 dependencies = [
  "quote",
- "syn 3.0.6",
+ "syn 3.0.9",
 ]
 
 [[package]]
@@ -5160,9 +5111,9 @@ dependencies = [
 
 [[package]]
 name = "proton-rpgp"
-version = "0.6.0"
+version = "0.9.0"
 source = "sparse+https://rust-registry.proton.me/index/"
-checksum = "6e4b8a64d41b39e5b5575a8c9f2b0bfb731dc7b8851efdc954d943699ccfe85c"
+checksum = "3ce47cad86b61e8101c3a1b1d57ff912be80be063513ed9f34f5ea0b5bf0660c"
 dependencies = [
  "hex",
  "kem",
@@ -5174,14 +5125,15 @@ dependencies = [
  "smallvec",
  "thiserror 1.0.69",
  "web-time",
+ "x25519-dalek",
  "zeroize",
 ]
 
 [[package]]
 name = "proton-srp"
-version = "0.8.3"
+version = "0.8.4"
 source = "sparse+https://rust-registry.proton.me/index/"
-checksum = "b5faf161c5694eb762a27f0e6327a430e197ccecaf6229def019e8ab6e934dc0"
+checksum = "95a019e90eeadabcf9fa58c27c06fafcd968443287133071a893d6fb4177cdb0"
 dependencies = [
  "base64 0.22.1",
  "bcrypt",
@@ -5199,9 +5151,9 @@ dependencies = [
 
 [[package]]
 name = "psl"
-version = "2.1.238"
+version = "2.1.243"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "2e6aa2cd4e8e062e78ac5d7df6206e2f8e39b624f658efd6f34f9aa1928ac5da"
+checksum = "6600966e937eeb6e279d7d5a35b9c61ca720f4a5ab6c950a3b921ca4881e0054"
 dependencies = [
  "psl-types",
 ]
@@ -5212,6 +5164,15 @@ version = "2.0.11"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "33cb294fe86a74cbcf50d4445b37da762029549ebeea341421c7c70370f86cac"
 
+[[package]]
+name = "psm"
+version = "0.1.24"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "200b9ff220857e53e184257720a14553b2f4aa02577d2ed9842d45d4b9654810"
+dependencies = [
+ "cc",
+]
+
 [[package]]
 name = "public-suffix"
 version = "0.1.3"
@@ -5496,7 +5457,7 @@ checksum = "92ecd8964f8453721699a1ed72037b0db49ce2f5a5138486ee89bed6f67cdf3a"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 3.0.6",
+ "syn 3.0.9",
 ]
 
 [[package]]
@@ -5683,16 +5644,16 @@ dependencies = [
 
 [[package]]
 name = "rsa"
-version = "0.10.0-rc.18"
+version = "0.10.0-rc.19"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "30b2aa4ba0d89f73d1e332df05be0eeab8840351c36ca5654341dfdb57bb3caf"
+checksum = "33405e321e16ef941ca66e254f6904c3aafd3c7ff001fb88bf11c73eb75c2b85"
 dependencies = [
  "const-oid 0.10.2",
  "crypto-bigint 0.7.5",
  "crypto-primes",
  "digest 0.11.3",
  "rand_core 0.10.1",
- "sha2 0.11.0",
+ "sha2 0.11.1",
  "signature 3.0.0",
  "zeroize",
 ]
@@ -5799,9 +5760,9 @@ dependencies = [
 
 [[package]]
 name = "rustls-native-certs"
-version = "0.8.4"
+version = "0.8.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "dab5152771c58876a2146916e53e35057e1a4dfa2b9df0f0305b07f611fdea4d"
+checksum = "4a073f5dc7469f984c52ad2752b63b0807745133b6de880b7b64c1ac4c48aec4"
 dependencies = [
  "openssl-probe",
  "rustls-pki-types",
@@ -5853,9 +5814,9 @@ dependencies = [
 
 [[package]]
 name = "schannel"
-version = "0.1.29"
+version = "0.1.30"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "91c1b7e4904c873ef0710c1f407dde2e6287de2bebc1bbbf7d430bb7cbffd939"
+checksum = "9cb23c424d8ee841bb4d813677ca237e2a610067d594fec130f87d6093495ab5"
 dependencies = [
  "windows-sys 0.61.2",
 ]
@@ -5874,9 +5835,9 @@ dependencies = [
 
 [[package]]
 name = "schemars"
-version = "1.2.2"
+version = "1.2.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "687274d293b6cdc6e73e0fee520bf2049650090d7164f87672d212a3c530cf4a"
+checksum = "ab508826f74a77ca9d5aba6ff19b522583ee3eaf28a19384ff3d0e5835fadf6e"
 dependencies = [
  "dyn-clone",
  "ref-cast",
@@ -5963,7 +5924,7 @@ dependencies = [
  "num",
  "once_cell",
  "serde",
- "sha2 0.11.0",
+ "sha2 0.11.1",
  "zbus",
 ]
 
@@ -6000,15 +5961,6 @@ dependencies = [
  "serde_core",
 ]
 
-[[package]]
-name = "send_wrapper"
-version = "0.6.0"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "cd0b0ec5f1c1ca621c432a25813d8d60c88abe6d3e08a3eb9cf37d97a0fe3d73"
-dependencies = [
- "futures-core",
-]
-
 [[package]]
 name = "serde"
 version = "1.0.229"
@@ -6057,7 +6009,7 @@ checksum = "e7a5d71263a5a7d47b41f6b3f06ba276f10cc18b0931f1799f710578e2309348"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 3.0.6",
+ "syn 3.0.9",
 ]
 
 [[package]]
@@ -6073,10 +6025,11 @@ dependencies = [
 
 [[package]]
 name = "serde_json"
-version = "1.0.151"
+version = "1.0.154"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c841b55ecdae098c80dcae9cf767f6f8a0c2cdb3416bbef72181df4d0fe73f14"
+checksum = "e7e9cc8b1b85264074fbcc02a88680c4096b1e47df8f739dceb03bf482f04bd6"
 dependencies = [
+ "foldhash",
  "indexmap 2.14.2",
  "itoa",
  "memchr",
@@ -6115,14 +6068,14 @@ checksum = "8d3b1629de253c70a0508c3899572da79ca359fdab27c7920ff00406df418906"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 3.0.6",
+ "syn 3.0.9",
 ]
 
 [[package]]
 name = "serde_spanned"
-version = "1.1.1"
+version = "1.1.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "6662b5879511e06e8999a8a235d848113e942c9124f211511b16466ee2995f26"
+checksum = "4e7523beb55eece201a2356bee0bbca0d1ab466c14c07703b2e0ee6d42cb0c2c"
 dependencies = [
  "serde_core",
 ]
@@ -6153,7 +6106,7 @@ dependencies = [
  "indexmap 2.14.2",
  "jiff",
  "schemars 0.9.0",
- "schemars 1.2.2",
+ "schemars 1.2.3",
  "serde_core",
  "serde_json",
  "serde_with_macros",
@@ -6169,7 +6122,7 @@ dependencies = [
  "darling 0.24.1",
  "proc-macro2",
  "quote",
- "syn 3.0.6",
+ "syn 3.0.9",
 ]
 
 [[package]]
@@ -6204,9 +6157,9 @@ dependencies = [
 
 [[package]]
 name = "service-binding"
-version = "3.0.0"
+version = "3.0.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "25663b9d8b83193ef83183edb3fd01e5447adb3e5baa35466ff9a6cd2408d6e8"
+checksum = "ca7589fb29bd43a2eccdc7331723ecf898243ca95a94aa8855bc0e117c3c867f"
 dependencies = [
  "raunch",
 ]
@@ -6257,9 +6210,9 @@ dependencies = [
 
 [[package]]
 name = "sha2"
-version = "0.11.0"
+version = "0.11.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "446ba717509524cb3f22f17ecc096f10f4822d76ab5c0b9822c5f9c284e825f4"
+checksum = "47d7069beb7d6ac7b9acd1039986e73443f24234f41074da099d6f994ac9ad19"
 dependencies = [
  "cfg-if",
  "cpufeatures 0.3.1",
@@ -6393,9 +6346,9 @@ dependencies = [
 
 [[package]]
 name = "smallvec"
-version = "1.16.2"
+version = "1.16.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f9395f0f0eee849a9b707b2f06bb92a6a422090e2123bb2ef8e87a0e61892a8e"
+checksum = "5b3dc8af474f516a851ff4bd12db780f948b9250ad37211e4eec0bccea54e01b"
 dependencies = [
  "serde",
 ]
@@ -6464,9 +6417,9 @@ dependencies = [
 
 [[package]]
 name = "spki"
-version = "0.8.0"
+version = "0.8.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1d9efca8738c78ee9484207732f728b1ef517bbb1833d6fc0879ca898a522f6f"
+checksum = "7ef958a98b9d5da290cfc78946e9f3e61e1e62a18db0d92cac0b83cc161491a9"
 dependencies = [
  "base64ct",
  "der 0.8.2",
@@ -6492,9 +6445,9 @@ dependencies = [
 
 [[package]]
 name = "ssh-agent-client-rs"
-version = "1.1.3"
+version = "1.1.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d0eca9f3c8984d0deb4e773ab3bb8aab0c9c0276b63b72d82c090fe58a620cf9"
+checksum = "4d22c5f4ab58452cce2806ef98abec5012c078aeb07936ea13d8a39928b3af2b"
 dependencies = [
  "bytes",
  "interprocess",
@@ -6620,9 +6573,9 @@ dependencies = [
  "p384 0.14.0",
  "p521 0.14.0",
  "rand_core 0.10.1",
- "rsa 0.10.0-rc.18",
+ "rsa 0.10.0-rc.19",
  "sec1 0.8.1",
- "sha2 0.11.0",
+ "sha2 0.11.1",
  "signature 3.0.0",
  "ssh-cipher 0.3.0",
  "ssh-encoding 0.3.0",
@@ -6635,6 +6588,19 @@ version = "1.2.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "6ce2be8dc25455e1f91df71bfa12ad37d7af1092ae736f3a6cd0e37bc7810596"
 
+[[package]]
+name = "stacker"
+version = "0.1.25"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "707f49d46706bacf8a2b00d51dace3f9de527c13eec3778f570c411f89e69967"
+dependencies = [
+ "cc",
+ "cfg-if",
+ "libc",
+ "psm",
+ "windows-sys 0.61.2",
+]
+
 [[package]]
 name = "static_assertions"
 version = "1.1.0"
@@ -6708,9 +6674,9 @@ dependencies = [
 
 [[package]]
 name = "syn"
-version = "3.0.6"
+version = "3.0.9"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8593e8e72159ed2257d083c7a454a85cbf854f37a0966d8d483aff8c8a3ebcee"
+checksum = "d78c8dee4c7bf0e14673097256fed6142ce9d3b85a408189d07482442145823b"
 dependencies = [
  "proc-macro2",
  "quote",
@@ -6745,7 +6711,7 @@ checksum = "901704edd0dfe137f1987838ee4f259e4e063c31371bdb423f7ae38ec6f77f02"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 3.0.6",
+ "syn 3.0.9",
 ]
 
 [[package]]
@@ -6850,7 +6816,7 @@ checksum = "fe5197923287db20a58125f0bc85c062f7f2c892de97b18c356f9efb14b28524"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 3.0.6",
+ "syn 3.0.9",
 ]
 
 [[package]]
@@ -6911,9 +6877,9 @@ checksum = "fd3ca314f692efd6c868f8408f53fe444634a845f96c028b97d35f6a1f79f0ee"
 
 [[package]]
 name = "tokio"
-version = "1.53.1"
+version = "1.54.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "202caea871b69668250d242070849eb495be178ed697a3e98aebce5bc81a0bed"
+checksum = "a0c168a474b95bfecfe908a65d4bdffc523144b649a74c09c286afb35d53e0bc"
 dependencies = [
  "bytes",
  "libc",
@@ -6934,7 +6900,7 @@ checksum = "78773a2a397f451582ce068015985c33193cf6dea8b74d2a639fe457b2f07b0e"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 3.0.6",
+ "syn 3.0.9",
 ]
 
 [[package]]
@@ -6959,9 +6925,9 @@ dependencies = [
 
 [[package]]
 name = "tokio-util"
-version = "0.7.19"
+version = "0.7.20"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "494815d09bf52b5548659851081238f0ca39ff638363907596da739561c62c52"
+checksum = "e464cf451ba96ebfc6f9b6542f17ee8b8956e33f1e40d9690624e59d7a7f8a4b"
 dependencies = [
  "bytes",
  "futures-core",
@@ -6973,9 +6939,9 @@ dependencies = [
 
 [[package]]
 name = "toml"
-version = "1.1.6+spec-1.1.0"
+version = "1.1.8+spec-1.1.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "920602543f0911ab71da12c50d59701da54c196d1a2bf5cb4b75667f137a406a"
+checksum = "20489e00e4d8741d6be680764cc12e270655e375a20d1011e844a9c3379e678d"
 dependencies = [
  "indexmap 2.14.2",
  "serde_core",
@@ -6988,18 +6954,18 @@ dependencies = [
 
 [[package]]
 name = "toml_datetime"
-version = "1.1.1+spec-1.1.0"
+version = "1.1.2+spec-1.1.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "3165f65f62e28e0115a00b2ebdd37eb6f3b641855f9d636d3cd4103767159ad7"
+checksum = "2b86d767906c6c42421dcba507eb9d203e779497710a47782a224bb871653053"
 dependencies = [
  "serde_core",
 ]
 
 [[package]]
 name = "toml_edit"
-version = "0.25.15+spec-1.1.0"
+version = "0.25.17+spec-1.1.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1340ea94a5856333492c9064b02c778b191dd2c853778d9609debdcdfea3a614"
+checksum = "e3641d5bbb5349a79e1020a242d251efbc546ad8048d133958323ce9c40a9c9c"
 dependencies = [
  "indexmap 2.14.2",
  "toml_datetime",
@@ -7009,18 +6975,18 @@ dependencies = [
 
 [[package]]
 name = "toml_parser"
-version = "1.1.3+spec-1.1.0"
+version = "1.1.5+spec-1.1.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1d38ac1cf9b95face32296c0a3ede1fdc270627c9d9c02a7274dd6d960dc4d56"
+checksum = "baa693a8032d7e1cada7d0041e96126df243179ff061456783ac7f12bda4744c"
 dependencies = [
  "winnow",
 ]
 
 [[package]]
 name = "toml_writer"
-version = "1.1.2+spec-1.1.0"
+version = "1.1.3+spec-1.1.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "7d56353a2a665ad0f41a421187180aab746c8c325620617ad883a99a1cbe66d2"
+checksum = "06bdbd8cfc056b8d2e2e85f29b56a3bdbecb527cef81eb39e3e7b98af4652770"
 
 [[package]]
 name = "totp-rs"
@@ -7182,9 +7148,9 @@ dependencies = [
 
 [[package]]
 name = "typed-path"
-version = "0.12.3"
+version = "0.12.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8e28f89b80c87b8fb0cf04ab448d5dd0dd0ade2f8891bae878de66a75a28600e"
+checksum = "54ec2755506471f54baf5e4bb5499d8e510cc1caf271270e778a736bd2d7336c"
 
 [[package]]
 name = "typenum"
@@ -7211,15 +7177,15 @@ dependencies = [
 
 [[package]]
 name = "unicase"
-version = "2.9.0"
+version = "2.10.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "dbc4bc3a9f746d862c45cb89d705aa10f187bb96c76001afab07a0d35ce60142"
+checksum = "357cc3acc6a036009fd6c973ed009037c732d60d0b4f6c673e9041497482a28f"
 
 [[package]]
 name = "unicode-ident"
-version = "1.0.26"
+version = "1.0.27"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d245f478577f809a851594d02313b640fb437e0bb33866753cff937863096954"
+checksum = "a2c754d6c33795a1c324727428e5a7dedb5b06195f9890bdbcba760d3e246563"
 
 [[package]]
 name = "unicode-segmentation"
@@ -7246,9 +7212,7 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "76407f5f396a2c949a069eff4a9fca9ce462410eb872bffef4c2b7b89804a77a"
 dependencies = [
  "anyhow",
- "camino",
  "cargo_metadata",
- "clap",
  "uniffi_bindgen",
  "uniffi_core",
  "uniffi_macros",
@@ -7420,9 +7384,9 @@ checksum = "06abde3611657adf66d383f00b093d7faecc7fa57071cce2578660c9f1010821"
 
 [[package]]
 name = "uuid"
-version = "1.26.1"
+version = "1.28.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "2ef6dac1e96601b4fb3acccccff2139741fcb757cb9a36089bf5be91cfb285ce"
+checksum = "7cc1186384beb7dd8eedea376413fd654937285ea6c9cfbb928dc3043ea4b606"
 dependencies = [
  "getrandom 0.4.3",
  "js-sys",
@@ -7460,9 +7424,9 @@ dependencies = [
 
 [[package]]
 name = "want"
-version = "0.3.1"
+version = "0.3.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "bfa7760aed19e106de2c7c0b581b509f2f25d3dacaf737cb82ac61bc6d760b0e"
+checksum = "ec4cdd0dd910afe868b7ef477227d8d538b46b3075031afee8a9f2acb0a2ed0b"
 dependencies = [
  "try-lock",
 ]
@@ -7525,7 +7489,7 @@ dependencies = [
  "bumpalo",
  "proc-macro2",
  "quote",
- "syn 3.0.6",
+ "syn 3.0.9",
  "wasm-bindgen-shared",
 ]
 
@@ -7573,9 +7537,9 @@ dependencies = [
 
 [[package]]
 name = "webpki-roots"
-version = "1.0.9"
+version = "1.0.10"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "7dcd9d09a39985f5344844e66b0c530a33843579125f23e21e9f0f220850f22a"
+checksum = "1c1c8e20c8a38fc7d65abfe74eb7280e4aa667e8eec8bc84996d2874810748d9"
 dependencies = [
  "rustls-pki-types",
 ]
@@ -7964,7 +7928,7 @@ checksum = "ec8ebde2db3681e8c9980cc27822030e68752690ddfa9473e739aeb4dbde6d71"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 3.0.6",
+ "syn 3.0.9",
  "synstructure 0.14.0",
 ]
 
@@ -8023,7 +7987,7 @@ dependencies = [
  "proc-macro-crate",
  "proc-macro2",
  "quote",
- "syn 3.0.6",
+ "syn 3.0.9",
  "zbus_names",
  "zvariant",
  "zvariant_utils",
@@ -8031,9 +7995,9 @@ dependencies = [
 
 [[package]]
 name = "zbus_names"
-version = "4.3.4"
+version = "4.3.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d8bf88b4a3ff53e883001e0e0115b297a9d53c31b9c1edd2bfdd853e3428624e"
+checksum = "812a12be4ead7a59e18ea8f047d08add0066b73bc62fc1467066a2472ae088dd"
 dependencies = [
  "serde",
  "winnow",
@@ -8061,11 +8025,11 @@ dependencies = [
 
 [[package]]
 name = "zerocopy"
-version = "0.8.59"
+version = "0.8.63"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "6df92bf3d9227be3d53173901ddbffac2babc27ae50f397776ffd6dc33f800cb"
+checksum = "e5fe1f8f1b06191a00962174c61aa5005e0bb391a6d80d07e24d115c01a92ed8"
 dependencies = [
- "zerocopy-derive 0.8.59",
+ "zerocopy-derive 0.8.63",
 ]
 
 [[package]]
@@ -8081,9 +8045,9 @@ dependencies = [
 
 [[package]]
 name = "zerocopy-derive"
-version = "0.8.59"
+version = "0.8.63"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "ac4f328cf2f05d084e496c3e9c3f33ed0a183656a16e1fcec4d464d8373aec82"
+checksum = "863ad3ac83293fb4d740aedbfdc9240dd8d1a50c1099acd76ce80ce7c7230c7f"
 dependencies = [
  "proc-macro2",
  "quote",
@@ -8107,15 +8071,15 @@ checksum = "f75b4683f6c7f45248d4d64056a24298c6281e0993356d7d1b4a1a962ef10d4a"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 3.0.6",
+ "syn 3.0.9",
  "synstructure 0.14.0",
 ]
 
 [[package]]
 name = "zeroize"
-version = "1.9.0"
+version = "1.9.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e13c156562582aa81c60cb29407084cdb54c4164760106ab78e6c5b0858cf64e"
+checksum = "e13084392c5e4bc371903e2935a5eaeed24905a7511356b883835e18a78f6879"
 dependencies = [
  "zeroize_derive",
 ]
@@ -8167,14 +8131,14 @@ checksum = "34df6fc39dbd26ddc9c10e6a2984476e13acce22e64e4487636ef494369225da"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 3.0.6",
+ "syn 3.0.9",
 ]
 
 [[package]]
 name = "zip"
-version = "9.0.4"
+version = "9.0.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a954114b47a54df49f83d2722814e86b23d4bb1b54a1b90fb7d92b41619ddc22"
+checksum = "6e04976da629d3b04204ba8105b396a193af8ad2583b2c79bfb3ab8af580a11e"
 dependencies = [
  "aes 0.9.3",
  "bzip2",
@@ -8212,9 +8176,9 @@ checksum = "29666d0abbfad1e3dc4dcf6144730dd3a3ab225bbbdac83319345b1b44ccfc1b"
 
 [[package]]
 name = "zopfli"
-version = "0.8.3"
+version = "0.8.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f05cd8797d63865425ff89b5c4a48804f35ba0ce8d125800027ad6017d2b5249"
+checksum = "aaf7fc5d30c28483d93805c4a5e12b05bbb52407fa67c5f8bd552374cd01fb11"
 dependencies = [
  "bumpalo",
  "crc32fast",
@@ -8224,27 +8188,27 @@ dependencies = [
 
 [[package]]
 name = "zstd"
-version = "0.14.2"
+version = "0.14.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "057cfd910cfac363a0ada849592624b4c9ff2e10bef504c3433810d78ed96f93"
+checksum = "db3ae9bf90af6e40197bef767eeefc46ad6397420fe873830bd85e5fbbfb3c70"
 dependencies = [
  "zstd-safe",
 ]
 
 [[package]]
 name = "zstd-safe"
-version = "8.1.0"
+version = "8.2.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "bdd44c6a7284e91f3717755b24315a302edd9153a01f753c3cba3d765e8eafac"
+checksum = "ded520f16b29e1a9b771c722221b2b0a0398c2316d9bb3c42b458a5414d7434b"
 dependencies = [
  "zstd-sys",
 ]
 
 [[package]]
 name = "zstd-sys"
-version = "2.1.1+zstd.1.5.7"
+version = "2.1.2+zstd.1.5.7"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "aeec9eaf2dffbbd09201e23bd0ffcbaa33bb8e9266a10734fd7ed90a85eca078"
+checksum = "481ada9c543b2323cbb7bbdbb5249177fbf0188ed959ed2c15e4b22421c84ed3"
 dependencies = [
  "cc",
  "pkg-config",
@@ -8252,9 +8216,9 @@ dependencies = [
 
 [[package]]
 name = "zvariant"
-version = "5.15.0"
+version = "5.15.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c1d34c27cc6cdd1f458427519dd6b8612f7b7e3f7b9a0b2355d041dda9869147"
+checksum = "80bf6d6cd6a4b601acb64cfb8284cdc643fcfa75ef26ae3c46ec8aa4e8a1fbb7"
 dependencies = [
  "endi",
  "enumflags2",
@@ -8267,14 +8231,14 @@ dependencies = [
 
 [[package]]
 name = "zvariant_derive"
-version = "5.15.0"
+version = "5.15.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "864155e69b4352db0c7f374917bf45d1e0c8d17659c8b3dbf9795f3673f8c497"
+checksum = "ef2672456ba1cb54b5eaec136e63135b3c7495fb938e53b28a62e633496d486d"
 dependencies = [
  "proc-macro-crate",
  "proc-macro2",
  "quote",
- "syn 3.0.6",
+ "syn 3.0.9",
  "zvariant_utils",
 ]
 
@@ -8287,6 +8251,6 @@ dependencies = [
  "proc-macro2",
  "quote",
  "serde",
- "syn 3.0.6",
+ "syn 3.0.9",
  "winnow",
 ]
diff --git a/Cargo.toml b/Cargo.toml
index 297743b..26c1541 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -8,8 +8,6 @@ default-members = [
     "pass-fs",
     "pass",
     "pass-derive",
-    # maturin runs its `uniffi-bindgen` bin (in the default members) to generate the Python bindings
-    "pass-uniffi-bindgen"
 ]
 resolver = "2"
 
