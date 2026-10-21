class OpenapiTui < Formula
  desc "TUI to list, browse and run APIs defined with openapi spec"
  homepage "https://github.com/zaghaghi/openapi-tui"
  url "https://github.com/zaghaghi/openapi-tui/archive/refs/tags/0.10.2.tar.gz"
  sha256 "e9ca7bc160ca6fdf50f7534318589fcb725564c05b81f40742e37a422f35a191"
  license "MIT"
  head "https://github.com/zaghaghi/openapi-tui.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b5df572439ff88546c0fdb844b6ff0b8fb844d751f626977e2b3fcf4fafafd6d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fc66816a224994b3047b9cfbbd64295c8830e2fc21d9a340db473fc5de761964"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ce9e1a9b5e68e11c42e43949e8738b648dc91cd444ea84c1cba48e12b589b1f6"
    sha256 cellar: :any,                 arm64_linux:       "32f74b8dca6dd529fa41deba1d5ff97f2415f1f9d80d3c30aeb06c1e5378d0ba"
    sha256 cellar: :any,                 x86_64_linux:      "3a2a74500c667e1f6efe8693813d48ea7e02ddecab790db2a381830860d2814c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi-tui --version")

    openapi_url = "https://raw.githubusercontent.com/Tufin/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test1.yaml"

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"openapi-tui", "--input", openapi_url, [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn bin/"openapi-tui", "--input", openapi_url, [:out, :err] => output_log.to_s
        r.winsize = [80, 43]
      end
      sleep 1
      assert_match "APIs", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 12b1273..7e1f00b 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -2261,9 +2261,9 @@ dependencies = [
 
 [[package]]
 name = "openssl"
-version = "0.10.71"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5e14130c6a98cd258fdcb0fb6d744152343ff729cbfcb28c656a9d12b999fbcd"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.11.0",
  "cfg-if",
@@ -2302,9 +2302,9 @@ dependencies = [
 
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
