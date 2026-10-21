class Gitlogue < Formula
  desc "Cinematic Git commit replay tool"
  homepage "https://github.com/unhappychoice/gitlogue"
  url "https://github.com/unhappychoice/gitlogue/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "1d271302883be633d7d8dfdb7540d2382f2ab0742c9772e43a585e769230ea29"
  license "ISC"
  head "https://github.com/unhappychoice/gitlogue.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0e836415cefe7aff2a809b38b18c6640c88d0e125891346d86c693d548b86b95"
    sha256 cellar: :any, arm64_tahoe:       "4bc975efe411ef6196721117290251c2a360566a03f0a136e990a61c7afec627"
    sha256 cellar: :any, arm64_sequoia:     "405b4fe91564718e05a52a500090d3d15033432a2698fb9d9362bdbf79c1330b"
    sha256 cellar: :any, arm64_linux:       "77e90d887d1daf13ceb1be806b7693e9db86cf38b5baf74140032061fa4c73fb"
    sha256 cellar: :any, x86_64_linux:      "95d1d0db0d287a3a3eef69be068c3b67ca85b19d32d82b67c69e093e4d3a9d7b"
  end

  depends_on "openssl@4" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Update to openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  # Issue ref: https://github.com/unhappychoice/gitlogue/issues/226
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlogue --version")

    assert_match "Error: Not a Git repository", shell_output("#{bin}/gitlogue 2>&1", 1)
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 698ae5b..ce63719 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1197,9 +1197,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.111"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "82cab2d520aa75e3c58898289429321eb788c3106963d0dc886ec7a5f4adc321"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
