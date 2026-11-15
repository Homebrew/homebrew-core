class Gerust < Formula
  desc "Project generator for Rust backend projects"
  homepage "https://gerust.rs/"
  license "MIT"

  stable do
    url "https://github.com/mainmatter/gerust/archive/refs/tags/v0.0.6.tar.gz"
    sha256 "1036cc5461e91f775bf499575f2352cba8a91ac2c97d2b312bdc19601d300038"

    depends_on "openssl@4"

    # `cargo update --precise 0.9.114 openssl-sys` for minimum needed to use OpenSSL 4
    # TODO: Remove in the next release and replace openssl dependency with aws-lc
    patch :DATA
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "dce92a54ea226c22e48bc45fa9c9d498804ef98994b12e51d92be280d0d4ad95"
    sha256 cellar: :any, arm64_tahoe:       "ff96cbb5a7aa4292de83433d6e04285a51b82c1e8c6f671158c32f668cdc982e"
    sha256 cellar: :any, arm64_sequoia:     "1692fb674c42960e04779bc18667ebdc1bdab41a62f50292a00871d7b2db4108"
    sha256 cellar: :any, arm64_linux:       "0edcec4975a21ae3c60cb98ca069a1fba330b69e196fa60923ff3642ec000fd9"
    sha256 cellar: :any, x86_64_linux:      "f39f1bd702727ae57a238021c0b5442cd8e2a216c2e863de75e27fa8e97728ed"
  end

  head do
    url "https://github.com/mainmatter/gerust.git", branch: "main"

    depends_on "aws-lc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    if build.stable?
      ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    else
      ENV["AWS_LC_SYS_USE_SYSTEM"] = "1"
    end

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/gerust --version")

    (testpath/"brewtest").mkpath
    output = shell_output("#{bin}/gerust brewtest --minimal 2>&1")
    assert_match "Could not generate project!", output

    [
      formula_opt_lib("openssl@4")/shared_library("libssl"),
      formula_opt_lib("openssl@4")/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"gerust", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 80c06be..f44b38b 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1592,9 +1592,9 @@ checksum = "d05e27ee213611ffe7d6348b942e8f942b37114c00cc03cec254295a4a17852e"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.106"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8bb61ea9811cc39e3c2069f40b8b8e2e70d8569b361f879786cc7ed48b777cdd"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
