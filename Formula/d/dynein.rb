class Dynein < Formula
  desc "DynamoDB CLI"
  homepage "https://github.com/awslabs/dynein"
  license "Apache-2.0"

  stable do
    # TODO: Remove stable dependencies on next release and use head dependencies
    url "https://github.com/awslabs/dynein/archive/refs/tags/v0.3.0.tar.gz"
    sha256 "40be5866288f565ac00494910d5dbb266ca0c34d56d50d839bc2c2aad34dc470"

    depends_on "cmake" => :build # for libz-ng-sys crate

    uses_from_macos "bzip2"

    on_linux do
      depends_on "openssl@4" # need to build `openssl-sys`
    end

    # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
    # Can be removed in next release which no longer uses OpenSSL
    # https://github.com/awslabs/dynein/commit/59d5cf50edbec344a793957dfd881a680e758461
    patch :DATA
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c2f67983c1ee4e2ea57e211854b2762f47fff012698f4aeb5063bf2c5f19b18d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "03b76825a0eaa0ff6ea61348406e1a07237c3bbf80b96fb529ab528e18439da7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6274450d91604af5bcaac30b3c071696eca8d7b5f3cb4578b2015f53ec90808e"
    sha256 cellar: :any,                 arm64_linux:       "47de1fda8e1747e5d208bdff18a7440d20d6443c622d5394ff6f6c0468b4c037"
    sha256 cellar: :any,                 x86_64_linux:      "1deffed76308e0aae4f72e25928d59837047cea0da6ab00ffe238d7518480239"
  end

  head do
    url "https://github.com/awslabs/dynein.git", branch: "main"

    depends_on "aws-lc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["AWS_LC_SYS_USE_SYSTEM"] = "1" if build.head?

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "To find all tables in all regions", shell_output("#{bin}/dy desc 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/dy --version")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index bdd3b21..3b9e56c 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1750,9 +1750,9 @@ checksum = "3fdb12b2476b595f9358c5161aa467c2438859caa136dec86c26fdd2efe17b92"
 
 [[package]]
 name = "openssl"
-version = "0.10.64"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "95a0481286a310808298130d22dd1fef0fa571e05a8f44ec801801e84b216b1f"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.5.0",
  "cfg-if",
@@ -1782,9 +1782,9 @@ checksum = "ff011a302c396a5197692431fc1948019154afc178baf7d8e37367442a4601cf"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.102"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c597637d56fbc83893a35eb0dd04b2b8e7a50c91e64e9493e398b5df4fb45fa2"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
