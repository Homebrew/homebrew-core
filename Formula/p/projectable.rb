class Projectable < Formula
  desc "TUI file manager built for projects"
  homepage "https://dzfrias.dev/blog/projectable"
  url "https://github.com/dzfrias/projectable/archive/refs/tags/1.3.2.tar.gz"
  sha256 "8677aa186b50e28ae1addaa9178b65de9e07b3fcd54056fd92464b49c9f71312"
  license "MIT"
  revision 1
  head "https://github.com/dzfrias/projectable.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_golden_gate: "fe1c045bec3b443a01dd8347d82a6dd953cc60246e65417493a2dcfd08952593"
    sha256 cellar: :any,                 arm64_tahoe:       "ccd276c023c85a06dde2ee0d327f924e546178c408f67e83a955660c9175758d"
    sha256 cellar: :any,                 arm64_sequoia:     "807150e84939dc9e77f01e5d8e9c2b826456399a3c456b76292d99324c1ed7f7"
    sha256 cellar: :any,                 arm64_sonoma:      "56b10743eed8508024a1dee415c63095e932e45d78724186bce24cddb492f8d9"
    sha256 cellar: :any,                 sonoma:            "afd84a1fa7930a0e039333cc60402708cbb7a67156c2c90744c265e1e2583d99"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1120e3794cc5c73c58aaa6ce78f16ba76c7df6982f94de5eac0cbb616cfe2bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e5b7bbc33a02a2c7ba457562a08d857db94c73b60f7045e8306b487f7d9514d4"
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
