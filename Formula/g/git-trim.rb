class GitTrim < Formula
  desc "Trim your git remote tracking branches that are merged or gone"
  homepage "https://github.com/foriequal0/git-trim"
  url "https://github.com/foriequal0/git-trim.git",
      tag:      "v0.4.4",
      revision: "1f39d85ddb242e9933fba9faaecd6f423f2b6a5b"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "0f5332c306c9bead3b11d34b08e8448dd9aee5e3a7ec6549d73eb3aec396629a"
    sha256 cellar: :any, arm64_tahoe:       "45cf7521b7eac2ca8ae1f0569b8e9beb798a6c2592ee9ee80e6cfc4c2545092b"
    sha256 cellar: :any, arm64_sequoia:     "041850c879da3ba3dfad351b43a1c278bc0fa49b7973e40666a352a580bc0809"
    sha256 cellar: :any, arm64_linux:       "fbc5dcf647fb341023fa3918577ca07028b7e2a1ff1422ffd67abccd13287065"
    sha256 cellar: :any, x86_64_linux:      "d00a61425fe10e74c566e3062ca474ca9a83f97846320f87acadbff66b54360e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libssh2"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Update to openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # TODO: ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", *std_cargo_args
    man1.install "docs/git-trim.man" => "git-trim.1"
  end

  test do
    system "git", "clone", "https://github.com/foriequal0/git-trim"
    Dir.chdir("git-trim")
    system "git", "branch", "brew-test"
    assert_match "brew-test", shell_output("git trim")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 6cc4c66..2ed2e87 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1489,11 +1489,10 @@ checksum = "ff011a302c396a5197692431fc1948019154afc178baf7d8e37367442a4601cf"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.78"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "07d5c8cb6e57b3a3612064d7b18b117912b4ce70955c2504d4b741c9e244b132"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
- "autocfg",
  "cc",
  "libc",
  "pkg-config",
