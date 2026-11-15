class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/refs/tags/v0.2.77.tar.gz"
  sha256 "b13329704c5eab7c74ebc29c3f2209290ea00e758139daaefc0ab0d5728c2fa4"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "adb9b5aa54eca4c05a55b2684d87a19b8e763303a0e6b95717b611c716740178"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4210c58439c612769aea0fca9e997de722a81698a717c440da35d3ec5329b31f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "31fe3f277c0867c897cf9b70c2fc447e1fc5358f99c600f2dc0a4345bcc0beab"
    sha256 cellar: :any,                 arm64_linux:       "aea73c383d377bd012d91d66c7978d904d19e47cf56372a311a23b54df7f9282"
    sha256 cellar: :any,                 x86_64_linux:      "71389553ae67a2fb65ca482d85277b0a6a47763a2c198f3228da1dd32a3a0409"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@4"
  end

  # rust 1.87.0 patch
  patch do
    url "https://gitlab.com/timvisee/ffsend/-/commit/29eb167d4367929a2546c20b3f2bbf890b63c631.diff"
    sha256 "e5171b23ffd3cc0f4f1d47b29d110735c211ce96ba601a166a66537df28ed1c4"
    type :backport
    resolves "https://gitlab.com/timvisee/ffsend/-/merge_requests/44"
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "contrib/completions/ffsend.bash" => "ffsend"
    fish_completion.install "contrib/completions/ffsend.fish"
    zsh_completion.install "contrib/completions/_ffsend"
  end

  test do
    system bin/"ffsend", "help"

    (testpath/"file.txt").write("test")
    url = shell_output("#{bin}/ffsend upload -Iq #{testpath}/file.txt").strip
    output = shell_output("#{bin}/ffsend del -I #{url} 2>&1")
    assert_match "File deleted", output
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 8f82361..9cf22d9 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1494,11 +1494,11 @@ dependencies = [
 
 [[package]]
 name = "openssl"
-version = "0.10.56"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "729b745ad4a5575dd06a3e1af1414bd330ee561c01b3899eb584baeaa8def17e"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
- "bitflags 1.3.2",
+ "bitflags 2.4.0",
  "cfg-if 1.0.0",
  "foreign-types",
  "libc",
@@ -1526,9 +1526,9 @@ checksum = "ff011a302c396a5197692431fc1948019154afc178baf7d8e37367442a4601cf"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.91"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "866b5f16f90776b9bb8dc1e1802ac6f0513de3a7a7465867bfbc563dc737faac"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
