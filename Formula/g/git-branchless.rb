class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  license any_of: ["Apache-2.0", "MIT"]
  revision 2
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  stable do
    url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.10.0.tar.gz"
    sha256 "1eb8dbb85839c5b0d333e8c3f9011c3f725e0244bb92f4db918fce9d69851ff7"

    # patch to use libgit2 1.9, upstream pr ref, https://github.com/arxanas/git-branchless/pull/1485
    patch :DATA
  end

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3efab33fd1452f9b179eb701f2f0b3ad59b836245d6466172a5ce5bacd54bb78"
    sha256 cellar: :any,                 arm64_sonoma:  "f3713da56ed61e4ba98216df90e57bde5dba088d9d54cc48b396e42bda4e87b7"
    sha256 cellar: :any,                 arm64_ventura: "916640be323bdacc4fd0ad5ed2803cb1a4584d52ada450ae97b26b400c9abde6"
    sha256 cellar: :any,                 sonoma:        "17d8fa92649b7b75f85551251c4bdea543489247b14292b31f02696aea408222"
    sha256 cellar: :any,                 ventura:       "ae5923a733959106c2f4de98cf3c069d736af1f644991abb4355ab2bb72d12df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1910e0339bf1ef3e04848b49becde5b03556c1e2c6c511f47c998f8ba7efa9b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "246ff33a6a9007356ee52818e9ac3697cec0d8b8a173987870a9a0b7577b1b4a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    # make sure git can find git-branchless
    ENV.prepend_path "PATH", bin

    system "cargo", "install", *std_cargo_args(path: "git-branchless")

    system "git", "branchless", "install-man-pages", man
  end

  test do
    system "git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"

    system "git", "branchless", "init"
    assert_match "Initial Commit", shell_output("git sl").strip

    linkage_with_libgit2 = (bin/"git-branchless").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index ecd3295..19168b5 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1756,9 +1756,9 @@ dependencies = [
 
 [[package]]
 name = "git2"
-version = "0.19.0"
+version = "0.20.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "b903b73e45dc0c6c596f2d37eccece7c1c8bb6e4407b001096387c63d0d93724"
+checksum = "3fda788993cc341f69012feba8bf45c0ba4f3291fcc08e214b4d5a7332d88aff"
 dependencies = [
  "bitflags 2.5.0",
  "libc",
@@ -2063,9 +2063,9 @@ checksum = "9c198f91728a82281a64e1f4f9eeb25d82cb32a5de251c6bd1b5154d63a8e7bd"
 
 [[package]]
 name = "libgit2-sys"
-version = "0.17.0+1.8.1"
+version = "0.18.0+1.9.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "10472326a8a6477c3c20a64547b0059e4b0d086869eee31e6d7da728a8eb7224"
+checksum = "e1a117465e7e1597e8febea8bb0c410f1c7fb93b1e1cddf34363f8390367ffec"
 dependencies = [
  "cc",
  "libc",
diff --git a/Cargo.toml b/Cargo.toml
index 1c806fa..fa0364a 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -69,7 +69,7 @@ git-branchless-smartlog = { version = "0.10.0", path = "git-branchless-smartlog"
 git-branchless-submit = { version = "0.10.0", path = "git-branchless-submit" }
 git-branchless-test = { version = "0.10.0", path = "git-branchless-test" }
 git-branchless-undo = { version = "0.10.0", path = "git-branchless-undo" }
-git2 = { version = "0.19.0", default-features = false }
+git2 = { version = "0.20.0", default-features = false }
 glob = "0.3.0"
 indexmap = "2.2.6"
 indicatif = { version = "0.17.8", features = ["improved_unicode"] }
diff --git a/git-branchless-invoke/src/lib.rs b/git-branchless-invoke/src/lib.rs
index eee43ff..a6cd973 100644
--- a/git-branchless-invoke/src/lib.rs
+++ b/git-branchless-invoke/src/lib.rs
@@ -117,12 +117,12 @@ fn install_tracing(effects: Effects) -> eyre::Result<impl Drop> {
 
 #[instrument]
 fn install_libgit2_tracing() {
-    fn git_trace(level: git2::TraceLevel, msg: &str) {
-        info!("[{:?}]: {}", level, msg);
+    fn git_trace(level: git2::TraceLevel, msg: &[u8]) {
+        info!("[{:?}]: {}", level, String::from_utf8_lossy(msg));
     }
 
-    if !git2::trace_set(git2::TraceLevel::Trace, git_trace) {
-        warn!("Failed to install libgit2 tracing");
+    if let Err(err) = git2::trace_set(git2::TraceLevel::Trace, git_trace) {
+        warn!("Failed to install libgit2 tracing: {err}");
     }
 }
 
