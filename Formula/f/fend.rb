class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  stable do
    url "https://github.com/printfn/fend/archive/refs/tags/v1.5.8.tar.gz"
    sha256 "2c53922b83b693c852581942ddcf8e02e1bcd691f30c00e8066cdd6ab2070b86"

    # Backport openssl and openssl-sys updates to support OpenSSL 4
    # https://github.com/printfn/fend/commit/0f4c1bb1e5f6ae6ce655d3cc85608223112ed3d4
    patch :DATA
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e198b7422c3fa7d29fe81cfcf5217ccc16cb1d913e847cbe19b556ce4e1995d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7f42544ef852d93cb0d6b129db48884bb910271f507c06facad44a6cd76e5c47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0c7cbd81d7a5db05284f968efc13bff3007c7bfb8748d29a02a8fb1e54bd94a1"
    sha256 cellar: :any,                 arm64_linux:       "29cd91e3028114059d6349b1a32fd89b379bc8df27489862ad1d618e76ec912c"
    sha256 cellar: :any,                 x86_64_linux:      "ae6633345d519c769157e0bbb85dc8f541e42a786e034e7eb80e8e1e26836958"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cli", features: "native-tls")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end

__END__
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -750,15 +750,14 @@ checksum = "42f5e15c9953c5e4ccceeb2e7382a716482c34515315f7b03532b8b4e8393d2d"
 
 [[package]]
 name = "openssl"
-version = "0.10.75"
+version = "0.10.80"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "08838db121398ad17ab8531ce9de97b244589089e290a384c900cb9ff7434328"
+checksum = "a45fa2aa886c42762255da344f0a0d313e254066c46aad76f300c3d3da62d967"
 dependencies = [
  "bitflags",
  "cfg-if",
  "foreign-types",
  "libc",
- "once_cell",
  "openssl-macros",
  "openssl-sys",
 ]
@@ -788,9 +787,9 @@ checksum = "7c87def4c32ab89d880effc9e097653c8da5d6ef28e6b539d313baaacfbafcbe"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.111"
+version = "0.9.116"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "82cab2d520aa75e3c58898289429321eb788c3106963d0dc886ec7a5f4adc321"
+checksum = "f28a22dc7140cda5f096e5e7724a6962ca81a7f8bfd2979f9b18c11af56318c4"
 dependencies = [
  "cc",
  "libc",
