class Licensure < Formula
  desc "FOSS License management tool for your projects"
  homepage "https://github.com/chasinglogic/licensure"
  license "GPL-3.0-only"
  head "https://github.com/chasinglogic/licensure.git", branch: "master"

  stable do
    url "https://github.com/chasinglogic/licensure/archive/refs/tags/0.2.0.tar.gz"
    sha256 "5841b650f48b5c84ba3d934715cb53c78d9353b7aa49901d1147e199c8287b42"

    # Unfortunately, building 0.2.0 was broken because of the `serde` dependency version
    # declaration was broken.
    #
    # The author (@chasinglogic) fixed it in this commit:
    #   https://github.com/chasinglogic/licensure/commit/eff42ac056bee12c2233fbf46ae0575e1f7bc0bb
    #
    # However, @chasinglogic did not release a new tag. Thus, let's embed this commit's
    # diff as a patch at the end of this formula (which really just updates dependency
    # version declarations).
    patch :DATA
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/licensure --version")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index f362777..2686fe9 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -48,21 +48,24 @@ dependencies = [

 [[package]]
 name = "autocfg"
-version = "0.1.7"
+version = "0.1.8"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1d49d90015b3c36167a20fe2810c5cd875ad504b39cff3d4eae7977e6b7c1cb2"
+checksum = "0dde43e75fd43e8a1bf86103336bc699aa8d17ad1be60c76c0bdfd4828e19b78"
+dependencies = [
+ "autocfg 1.1.0",
+]

 [[package]]
 name = "autocfg"
-version = "1.0.1"
+version = "1.1.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "cdb031dd78e28731d87d56cc8ffef4a8f36ca26c38fe2de700543e627f8a464a"
+checksum = "d468802bab17cbc0cc575e9b053f41e72aa36bfa6b7f55e3529ffa43161b97fa"

 [[package]]
 name = "backtrace"
-version = "0.3.63"
+version = "0.3.65"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "321629d8ba6513061f26707241fa9bc89524ff1cd7a915a97ef0c62c666ce1b6"
+checksum = "11a17d453482a265fd5f8479f2a3f405566e6ca627837aaddb85af8b1ab8ef61"
 dependencies = [
  "addr2line",
  "cc",
@@ -107,9 +110,9 @@ dependencies = [

 [[package]]
 name = "cc"
-version = "1.0.72"
+version = "1.0.73"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "22a9137b95ea06864e018375b72adfb7db6e6f68cfc8df5a04d00288050485ee"
+checksum = "2fff2a6927b3bb87f9595d67196a70493f627687a71d87a0d692242c33f58c11"

 [[package]]
 name = "cfg-if"
@@ -190,9 +193,9 @@ dependencies = [

 [[package]]
 name = "core-foundation"
-version = "0.9.2"
+version = "0.9.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "6888e10551bb93e424d8df1d07f1a8b4fceb0001a3a4b048bfc47554946f47b3"
+checksum = "194a7a9e6de53fa55116934067c844d9d749312f75c6f6d0980e8c252f8c2146"
 dependencies = [
  "core-foundation-sys",
  "libc",
@@ -206,9 +209,9 @@ checksum = "5827cebf4670468b8772dd191856768aedcb1b0278a04f989f7766351917b9dc"

 [[package]]
 name = "crc32fast"
-version = "1.3.0"
+version = "1.3.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "738c290dfaea84fc1ca15ad9c168d083b05a714e1efddd8edaab678dc28d2836"
+checksum = "b540bd8bc810d3885c6ea91e2018302f68baba2129ab3e88f32389ee9370880d"
 dependencies = [
  "cfg-if 1.0.0",
 ]
@@ -230,7 +233,7 @@ version = "0.8.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "058ed274caafc1f60c4997b5fc07bf7dc7cca454af7c6e81edffe5f33f70dace"
 dependencies = [
- "autocfg 1.0.1",
+ "autocfg 1.1.0",
  "cfg-if 0.1.10",
  "crossbeam-utils",
  "lazy_static",
@@ -256,7 +259,7 @@ version = "0.7.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "c3c7c73a2d1e9fc0886a08b93e98eb643461230d5f1925e4036204d5f2e261a8"
 dependencies = [
- "autocfg 1.0.1",
+ "autocfg 1.1.0",
  "cfg-if 0.1.10",
  "lazy_static",
 ]
@@ -275,9 +278,9 @@ checksum = "e78d4f1cc4ae33bbfc157ed5d5a5ef3bc29227303d595861deb238fcec4e9457"

 [[package]]
 name = "encoding_rs"
-version = "0.8.29"
+version = "0.8.31"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a74ea89a0a1b98f6332de42c95baff457ada66d1cb4030f9ff151b2041a1c746"
+checksum = "9852635589dc9f9ea1b6fe9f05b50ef208c85c834a562f0c6abb1c475736ec2b"
 dependencies = [
  "cfg-if 1.0.0",
 ]
@@ -304,11 +307,20 @@ dependencies = [
  "synstructure",
 ]

+[[package]]
+name = "fastrand"
+version = "1.7.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "c3fcf0cee53519c866c09b5de1f6c56ff9d647101f81c1964fa632e148896cdf"
+dependencies = [
+ "instant",
+]
+
 [[package]]
 name = "flate2"
-version = "1.0.22"
+version = "1.0.23"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1e6988e897c1c9c485f43b47a529cef42fde0547f9d8d41a7062518f1d8fc53f"
+checksum = "b39522e96686d38f4bc984b9198e3a0613264abaebaff2c5c918bfa6b6da09af"
 dependencies = [
  "cfg-if 1.0.0",
  "crc32fast",
@@ -385,17 +397,6 @@ dependencies = [
  "num_cpus",
 ]

-[[package]]
-name = "getrandom"
-version = "0.2.3"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "7fcd999463524c52659517fe2cea98493cfe485d10565e7b0fb07dbba7ad2753"
-dependencies = [
- "cfg-if 1.0.0",
- "libc",
- "wasi",
-]
-
 [[package]]
 name = "gimli"
 version = "0.26.1"
@@ -443,7 +444,7 @@ checksum = "d6ccf5ede3a895d8856620237b2f02972c1bbc78d2965ad7fe8838d4a0ed41f0"
 dependencies = [
  "bytes",
  "fnv",
- "itoa",
+ "itoa 0.4.8",
 ]

 [[package]]
@@ -460,9 +461,9 @@ dependencies = [

 [[package]]
 name = "httparse"
-version = "1.5.1"
+version = "1.7.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "acd94fdbe1d4ff688b67b04eee2e17bd50995534a61539e45adfefb45e5e5503"
+checksum = "6330e8a36bd8c859f3fa6d9382911fbb7147ec39807f63b923933a247240b9ba"

 [[package]]
 name = "hyper"
@@ -478,7 +479,7 @@ dependencies = [
  "http-body",
  "httparse",
  "iovec",
- "itoa",
+ "itoa 0.4.8",
  "log",
  "net2",
  "rustc_version",
@@ -531,14 +532,23 @@ dependencies = [

 [[package]]
 name = "indexmap"
-version = "1.7.0"
+version = "1.8.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "bc633605454125dec4b66843673f01c7df2b89479b32e0ed634e43a91cff62a5"
+checksum = "0f647032dfaa1f8b6dc29bd3edb7bbef4861b8b8007ebb118d6db284fd59f6ee"
 dependencies = [
- "autocfg 1.0.1",
+ "autocfg 1.1.0",
  "hashbrown",
 ]

+[[package]]
+name = "instant"
+version = "0.1.12"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "7a5bbe824c507c5da5956355e86a746d82e0e1464f65d862cc5e71da70e94b2c"
+dependencies = [
+ "cfg-if 1.0.0",
+]
+
 [[package]]
 name = "iovec"
 version = "0.1.4"
@@ -554,6 +564,12 @@ version = "0.4.8"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "b71991ff56294aa922b450139ee08b3bfc70982c6b2c7562771375cf73542dd4"

+[[package]]
+name = "itoa"
+version = "1.0.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "1aab8fc367588b89dcee83ab0fd66b72b50b72fa1904d7095045ace2b0c81c35"
+
 [[package]]
 name = "kernel32-sys"
 version = "0.2.2"
@@ -572,9 +588,9 @@ checksum = "e2abad23fbc42b3700f2f279844dc832adb2b2eb069b2df918f455c4e18cc646"

 [[package]]
 name = "libc"
-version = "0.2.109"
+version = "0.2.124"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f98a04dce437184842841303488f70d0188c5f51437d2a834dc097eafa909a01"
+checksum = "21a41fed9d98f27ab1c6d161da622a4fa35e8a54a8adc24bbf3ddd0ef70b0e50"

 [[package]]
 name = "licensure"
@@ -608,9 +624,9 @@ dependencies = [

 [[package]]
 name = "log"
-version = "0.4.14"
+version = "0.4.16"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "51b9bbe6c47d51fc3e1a9b945965946b4c44142ab8792c50835a980d362c2710"
+checksum = "6389c490849ff5bc16be905ae24bc913a9c8892e19b2341dbc175e14c341c2b8"
 dependencies = [
  "cfg-if 1.0.0",
 ]
@@ -639,7 +655,7 @@ version = "0.5.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "043175f069eda7b85febe4a74abbaeff828d9f8b448515d3151a14a3542811aa"
 dependencies = [
- "autocfg 1.0.1",
+ "autocfg 1.1.0",
 ]

 [[package]]
@@ -650,9 +666,9 @@ checksum = "2a60c7ce501c71e03a9c9c0d35b861413ae925bd979cc7a4e30d060069aaac8d"

 [[package]]
 name = "mime_guess"
-version = "2.0.3"
+version = "2.0.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "2684d4c2e97d99848d30b324b00c8fcc7e5c897b7cbb5819b09e7c90e8baf212"
+checksum = "4192263c238a5f0d0c6bfd21f336a313a4ce1c450542449ca191bb657b4642ef"
 dependencies = [
  "mime",
  "unicase",
@@ -660,12 +676,11 @@ dependencies = [

 [[package]]
 name = "miniz_oxide"
-version = "0.4.4"
+version = "0.5.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a92518e98c078586bc6c934028adcca4c92a53d6a958196de835170a01d84e4b"
+checksum = "d2b29bd4bc3f33391105ebee3589c19197c4271e3e5a9ec9bfe8127eeff8f082"
 dependencies = [
  "adler",
- "autocfg 1.0.1",
 ]

 [[package]]
@@ -701,9 +716,9 @@ dependencies = [

 [[package]]
 name = "native-tls"
-version = "0.2.8"
+version = "0.2.10"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "48ba9f7719b5a0f42f338907614285fb5fd70e53858141f69898a1fb7203b24d"
+checksum = "fd7e2f3618557f980e0b17e8856252eee3c97fa12c54dff0ca290fb6266ca4a9"
 dependencies = [
  "lazy_static",
  "libc",
@@ -734,7 +749,7 @@ version = "0.1.44"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "d2cc698a63b549a70bc047073d2949cce27cd1c7b0a4a862d08a8031bc2801db"
 dependencies = [
- "autocfg 1.0.1",
+ "autocfg 1.1.0",
  "num-traits",
 ]

@@ -744,14 +759,14 @@ version = "0.2.14"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "9a64b1ec5cda2586e284722486d802acf1f7dbdc623e2bfc57e65ca1cd099290"
 dependencies = [
- "autocfg 1.0.1",
+ "autocfg 1.1.0",
 ]

 [[package]]
 name = "num_cpus"
-version = "1.13.0"
+version = "1.13.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "05499f3756671c15885fee9034446956fff3f243d6077b91e5767df161f766b3"
+checksum = "19e64526ebdee182341572e50e9ad03965aa510cd94427a4549448f285e957a1"
 dependencies = [
  "hermit-abi",
  "libc",
@@ -759,18 +774,18 @@ dependencies = [

 [[package]]
 name = "object"
-version = "0.27.1"
+version = "0.28.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "67ac1d3f9a1d3616fd9a60c8d74296f22406a238b6a72f5cc1e6f314df4ffbf9"
+checksum = "40bec70ba014595f99f7aa110b84331ffe1ee9aece7fe6f387cc7e3ecda4d456"
 dependencies = [
  "memchr",
 ]

 [[package]]
 name = "once_cell"
-version = "1.8.0"
+version = "1.10.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "692fcb63b64b1758029e0a96ee63e049ce8c5948587f2f7208df04625e5f6b56"
+checksum = "87f3e037eac156d1775da914196f0f37741a274155e34a0b7e427c35d2a2ecb9"

 [[package]]
 name = "openssl"
@@ -788,17 +803,17 @@ dependencies = [

 [[package]]
 name = "openssl-probe"
-version = "0.1.4"
+version = "0.1.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "28988d872ab76095a6e6ac88d99b54fd267702734fd7ffe610ca27f533ddb95a"
+checksum = "ff011a302c396a5197692431fc1948019154afc178baf7d8e37367442a4601cf"

 [[package]]
 name = "openssl-sys"
-version = "0.9.71"
+version = "0.9.72"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "7df13d165e607909b363a4757a6f133f8a818a74e9d3a98d09c6128e15fa4c73"
+checksum = "7e46109c383602735fa0a2e48dd2b7c892b048e1bf69e5c3b1d804b7d9c203cb"
 dependencies = [
- "autocfg 1.0.1",
+ "autocfg 1.1.0",
  "cc",
  "libc",
  "pkg-config",
@@ -845,21 +860,15 @@ checksum = "d4fd5641d01c8f18a23da7b6fe29298ff4b55afcccdf78973b24cf3175fee32e"

 [[package]]
 name = "pkg-config"
-version = "0.3.22"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "12295df4f294471248581bc09bef3c38a5e46f1e36d6a37353621a0c6c357e1f"
-
-[[package]]
-name = "ppv-lite86"
-version = "0.2.15"
+version = "0.3.25"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "ed0cfbc8191465bed66e1718596ee0b0b35d5ee1f41c5df2189d0fe8bde535ba"
+checksum = "1df8c4ec4b0627e53bdf214615ad287367e482558cf84b109250b37464dc03ae"

 [[package]]
 name = "proc-macro2"
-version = "1.0.33"
+version = "1.0.37"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "fb37d2df5df740e582f28f8560cf425f52bb267d872fe58358eadb554909f07a"
+checksum = "ec757218438d5fda206afc041538b2f6d889286160d649a86a24d37e1235afd1"
 dependencies = [
  "unicode-xid",
 ]
@@ -876,9 +885,9 @@ dependencies = [

 [[package]]
 name = "quote"
-version = "1.0.10"
+version = "1.0.18"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "38bc8cc6a5f2e3655e0899c1b848643b2562f853f114bfec7be120678e3ace05"
+checksum = "a1feb54ed693b93a84e14094943b84b7c4eae204c512b7ccb95ab0c66d278ad1"
 dependencies = [
  "proc-macro2",
 ]
@@ -889,11 +898,11 @@ version = "0.6.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "6d71dacdc3c88c1fde3885a3be3fbab9f35724e6ce99467f7d9c5026132184ca"
 dependencies = [
- "autocfg 0.1.7",
+ "autocfg 0.1.8",
  "libc",
- "rand_chacha 0.1.1",
+ "rand_chacha",
  "rand_core 0.4.2",
- "rand_hc 0.1.0",
+ "rand_hc",
  "rand_isaac",
  "rand_jitter",
  "rand_os",
@@ -902,38 +911,16 @@ dependencies = [
  "winapi 0.3.9",
 ]

-[[package]]
-name = "rand"
-version = "0.8.4"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "2e7573632e6454cf6b99d7aac4ccca54be06da05aca2ef7423d22d27d4d4bcd8"
-dependencies = [
- "libc",
- "rand_chacha 0.3.1",
- "rand_core 0.6.3",
- "rand_hc 0.3.1",
-]
-
 [[package]]
 name = "rand_chacha"
 version = "0.1.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "556d3a1ca6600bfcbab7c7c91ccb085ac7fbbcd70e008a98742e7847f4f7bcef"
 dependencies = [
- "autocfg 0.1.7",
+ "autocfg 0.1.8",
  "rand_core 0.3.1",
 ]

-[[package]]
-name = "rand_chacha"
-version = "0.3.1"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e6c10a63a0fa32252be49d21e7709d4d4baf8d231c2dbce1eaa8141b9b127d88"
-dependencies = [
- "ppv-lite86",
- "rand_core 0.6.3",
-]
-
 [[package]]
 name = "rand_core"
 version = "0.3.1"
@@ -949,15 +936,6 @@ version = "0.4.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "9c33a3c44ca05fa6f1807d8e6743f3824e8509beca625669633be0acbdf509dc"

-[[package]]
-name = "rand_core"
-version = "0.6.3"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d34f1408f55294453790c48b2f1ebbb1c5b4b7563eb1f418bcfcfdbb06ebb4e7"
-dependencies = [
- "getrandom",
-]
-
 [[package]]
 name = "rand_hc"
 version = "0.1.0"
@@ -967,15 +945,6 @@ dependencies = [
  "rand_core 0.3.1",
 ]

-[[package]]
-name = "rand_hc"
-version = "0.3.1"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d51e9f596de227fda2ea6c84607f5558e196eeaf43c986b724ba4fb8fdf497e7"
-dependencies = [
- "rand_core 0.6.3",
-]
-
 [[package]]
 name = "rand_isaac"
 version = "0.1.1"
@@ -1016,7 +985,7 @@ version = "0.1.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "abf9b09b01790cfe0364f52bf32995ea3c39f4d2dd011eac241d2914146d0b44"
 dependencies = [
- "autocfg 0.1.7",
+ "autocfg 0.1.8",
  "rand_core 0.4.2",
 ]

@@ -1046,18 +1015,18 @@ checksum = "41cc0f7e4d5d4544e8861606a285bb08d3e70712ccc7d2b84d7c0ccfaf4b05ce"

 [[package]]
 name = "redox_syscall"
-version = "0.2.10"
+version = "0.2.13"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8383f39639269cde97d255a32bdb68c047337295414940c68bdd30c2e13203ff"
+checksum = "62f25bc4c7e55e0b0b7a1d43fb893f4fa1361d0abe38b9ce4f323c2adfe6ef42"
 dependencies = [
  "bitflags",
 ]

 [[package]]
 name = "regex"
-version = "1.5.4"
+version = "1.5.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d07a8629359eb56f1e2fb1652bb04212c072a87ba68546a04065d525673ac461"
+checksum = "1a11647b6b25ff05a515cb92c365cec08801e83423a235b51e231e1808747286"
 dependencies = [
  "aho-corasick",
  "memchr",
@@ -1130,9 +1099,9 @@ dependencies = [

 [[package]]
 name = "ryu"
-version = "1.0.6"
+version = "1.0.9"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "3c9613b5a66ab9ba26415184cfc41156594925a9cf3a2057e57f31ff145f6568"
+checksum = "73b4b750c782965c211b42f022f59af1fbceabdd026623714f104152f1ec149f"

 [[package]]
 name = "schannel"
@@ -1152,9 +1121,9 @@ checksum = "d29ab0c6d3fc0ee92fe66e2d99f700eab17a8d57d1c1d3b748380fb20baa78cd"

 [[package]]
 name = "security-framework"
-version = "2.4.2"
+version = "2.6.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "525bc1abfda2e1998d152c45cf13e696f76d0a4972310b22fac1658b05df7c87"
+checksum = "2dc14f172faf8a0194a3aded622712b0de276821addc574fa54fc0a1167e10dc"
 dependencies = [
  "bitflags",
  "core-foundation",
@@ -1165,9 +1134,9 @@ dependencies = [

 [[package]]
 name = "security-framework-sys"
-version = "2.4.2"
+version = "2.6.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a9dd14d83160b528b7bfd66439110573efcfbe281b17fc2ca9f39f550d619c7e"
+checksum = "0160a13a177a45bfb43ce71c01580998474f556ad854dcbca936dd2841a5c556"
 dependencies = [
  "core-foundation-sys",
  "libc",
@@ -1190,18 +1159,18 @@ checksum = "388a1df253eca08550bef6c72392cfe7c30914bf41df5269b68cbd6ff8f570a3"

 [[package]]
 name = "serde"
-version = "1.0.130"
+version = "1.0.136"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f12d06de37cf59146fbdecab66aa99f9fe4f78722e3607577a5375d66bd0c913"
+checksum = "ce31e24b01e1e524df96f1c2fdd054405f8d7376249a5110886fb4b658484789"
 dependencies = [
  "serde_derive",
 ]

 [[package]]
 name = "serde_derive"
-version = "1.0.130"
+version = "1.0.136"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d7bc1a1ab1961464eae040d96713baa5a724a8152c1222492465b54322ec508b"
+checksum = "08597e7152fcd306f41838ed3e37be9eaeed2b61c42e2117266a554fab4662f9"
 dependencies = [
  "proc-macro2",
  "quote",
@@ -1210,11 +1179,11 @@ dependencies = [

 [[package]]
 name = "serde_json"
-version = "1.0.72"
+version = "1.0.79"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d0ffa0837f2dfa6fb90868c2b5468cad482e175f7dad97e7421951e663f2b527"
+checksum = "8e8d9fa5c3b304765ce1fd9c4c8a3de2c8db365a5b91be52f186efc675681d95"
 dependencies = [
- "itoa",
+ "itoa 1.0.1",
  "ryu",
  "serde",
 ]
@@ -1226,28 +1195,28 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "642dd69105886af2efd227f75a520ec9b44a820d65bc133a9131f7d229fd165a"
 dependencies = [
  "dtoa",
- "itoa",
+ "itoa 0.4.8",
  "serde",
  "url 1.7.2",
 ]

 [[package]]
 name = "serde_yaml"
-version = "0.8.21"
+version = "0.8.23"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d8c608a35705a5d3cdc9fbe403147647ff34b921f8e833e49306df898f9b20af"
+checksum = "a4a521f2940385c165a24ee286aa8599633d162077a54bdcae2a6fd5a7bfa7a0"
 dependencies = [
- "dtoa",
  "indexmap",
+ "ryu",
  "serde",
  "yaml-rust",
 ]

 [[package]]
 name = "simplelog"
-version = "0.11.0"
+version = "0.11.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8baa24de25f3092d9697c76f94cf09f67fca13db2ea11ce80c2f055c1aaf0795"
+checksum = "c1348164456f72ca0116e4538bdaabb0ddb622c7d9f16387c725af3e96d6001c"
 dependencies = [
  "chrono",
  "log",
@@ -1256,9 +1225,9 @@ dependencies = [

 [[package]]
 name = "slab"
-version = "0.4.5"
+version = "0.4.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "9def91fd1e018fe007022791f865d0ccc9b3a0d5001e01aabb8b40e46000afb5"
+checksum = "eb703cfe953bccee95685111adeedb76fabe4e97549a58d16f03ea7b9367bb32"

 [[package]]
 name = "smallvec"
@@ -1292,9 +1261,9 @@ checksum = "8ea5119cdb4c55b55d432abb513a0429384878c15dde60cc77b1c99de1a95a6a"

 [[package]]
 name = "syn"
-version = "1.0.82"
+version = "1.0.91"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8daf5dd0bb60cbd4137b1b587d2fc0ae729bc07cf01cd70b36a1ed5ade3b9d59"
+checksum = "b683b2b825c8eef438b77c36a06dc262294da3d5a5813fac20da149241dcd44d"
 dependencies = [
  "proc-macro2",
  "quote",
@@ -1315,23 +1284,23 @@ dependencies = [

 [[package]]
 name = "tempfile"
-version = "3.2.0"
+version = "3.3.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "dac1c663cfc93810f88aed9b8941d48cabf856a1b111c29a40439018d870eb22"
+checksum = "5cdb1ef4eaeeaddc8fbd371e5017057064af0911902ef36b39801f67cc6d79e4"
 dependencies = [
  "cfg-if 1.0.0",
+ "fastrand",
  "libc",
- "rand 0.8.4",
- "redox_syscall 0.2.10",
+ "redox_syscall 0.2.13",
  "remove_dir_all",
  "winapi 0.3.9",
 ]

 [[package]]
 name = "termcolor"
-version = "1.1.2"
+version = "1.1.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "2dfed899f0eb03f32ee8c6a0aabdb8a7949659e3466561fc0adf54e26d88c5f4"
+checksum = "bab24d30b911b2376f3a13cc2cd443142f0c81dda04c118693e35b3835757755"
 dependencies = [
  "winapi-util",
 ]
@@ -1369,9 +1338,9 @@ dependencies = [

 [[package]]
 name = "tinyvec"
-version = "1.5.1"
+version = "1.6.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "2c1c1d5a42b6245520c249549ec267180beaffcc0615401ac8e31853d4b6d8d2"
+checksum = "87cc5ceb3875bb20c2890005a4e226a4651264a5c75edb2421b52861a0a0cb50"
 dependencies = [
  "tinyvec_macros",
 ]
@@ -1604,7 +1573,7 @@ version = "0.7.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "90dbc611eb48397705a6b0f6e917da23ae517e4d127123d2cf7674206627d32a"
 dependencies = [
- "rand 0.6.5",
+ "rand",
 ]

 [[package]]
@@ -1621,9 +1590,9 @@ checksum = "f1bddf1187be692e79c5ffeab891132dfb0f236ed36a43c7ed39f1165ee20191"

 [[package]]
 name = "version_check"
-version = "0.9.3"
+version = "0.9.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5fecdca9a5291cc2b8dcf7dc02453fee791a280f3743cb0905f8822ae463b3fe"
+checksum = "49874b5167b65d7193b8aba1567f5c7d93d001cafc34600cee003eda787e483f"

 [[package]]
 name = "want"
diff --git a/Cargo.toml b/Cargo.toml
index 06b5d12..4d32084 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -17,7 +17,7 @@ travis-ci = { repository = "chasinglogic/licensure", branch = "master" }
 chrono = "0.4.2"
 clap = "2.31.2"
 regex = "1.0.0"
-serde = { version = "0.2.0", features = ["derive"] }
+serde = { version = "1.0", features = ["derive"] }
 serde_yaml = "0.8.21"
 log = "0.4.8"
 simplelog = "0.11.0"
