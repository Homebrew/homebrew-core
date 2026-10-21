class Projectable < Formula
  desc "TUI file manager built for projects"
  homepage "https://dzfrias.dev/blog/projectable"
  url "https://github.com/dzfrias/projectable/archive/refs/tags/1.3.2.tar.gz"
  sha256 "8677aa186b50e28ae1addaa9178b65de9e07b3fcd54056fd92464b49c9f71312"
  license "MIT"
  revision 1
  head "https://github.com/dzfrias/projectable.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "aaf45d45edce5efdc573b17493aae3943ab8e8a959c081e27b21c847a42110de"
    sha256 cellar: :any, arm64_tahoe:       "1fc0fd148e1805b5db5e69d6cf9757665e78b7578ee06683e3ab6386a4bfef03"
    sha256 cellar: :any, arm64_sequoia:     "f211a3a7a50e3ffcb895616a213093f1855dcaa14fc7f42ce2ebc3fa055bd0cf"
    sha256 cellar: :any, arm64_linux:       "68d9c1a9cc62a5e936d1c50ec461f8d8b00472d8617696d0461a77de4e81cff7"
    sha256 cellar: :any, x86_64_linux:      "3cc373c1a6ac9ba3bcd3c4fdb61a3771817f9b16ec52b3f3e5265c25e2906834"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # `cargo update --precise 0.9.114 openssl-sys` for minimum needed to use OpenSSL 4
  patch :DATA

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    system bin/"prj", "--version"

    begin
      output_log = testpath/"output.log"
      pid = if OS.mac?
        spawn bin/"prj", testpath, [:out, :err] => output_log.to_s
      else
        require "pty"
        PTY.spawn("#{bin}/prj #{testpath} > #{output_log}").last
      end
      sleep 1
      assert_match "output.log", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end

    [
      formula_opt_lib("libgit2")/shared_library("libgit2"),
      formula_opt_lib("libssh2")/shared_library("libssh2"),
      formula_opt_lib("openssl@4")/shared_library("libcrypto"),
      formula_opt_lib("openssl@4")/shared_library("libssl"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"prj", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index a02e66d..d33692c 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1394,9 +1394,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.104"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "45abf306cbf99debc8195b66b7346498d7b10c210de50418b5ccd7ceba08c741"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
@@ -1545,7 +1545,7 @@ dependencies = [
 
 [[package]]
 name = "projectable"
-version = "1.3.1"
+version = "1.3.2"
 dependencies = [
  "ansi-to-tui",
  "anyhow",
