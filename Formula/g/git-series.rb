class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/refs/tags/0.9.1.tar.gz"
  sha256 "c0362e19d3fa168a7cb0e260fcdecfe070853b163c9f2dfd2ad8213289bc7e5f"
  license "MIT"
  revision 13

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6c0d251705744036205ea82afac6a4851e9a4cd1cc02023283a87c69aa776d6a"
    sha256 cellar: :any,                 arm64_sequoia: "cd487be11dce61dae6298686b051d08ed7ac9310ba31d7d4e746d0dbadc619a6"
    sha256 cellar: :any,                 arm64_sonoma:  "445b7335a3682c6f1cf57bdf7ba4af3ff4868d7035d2e1fa7aa379071af19afc"
    sha256 cellar: :any,                 sonoma:        "7e34b5d7fb0ab1cca8fb1f265875fc44ab125b3af7f7db7d1f47e815bffd3843"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84c7c8c0594606fafb7f6818644da387855e9a9d3a6ae7a4052a36febfac808f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd078426fe35d91cfa5c3d7b7e0dfd1f44746dcf33fb58d82bc1a670ab533fce"
  end

  # https://github.com/git-series/git-series/issues/74#issuecomment-2394973654
  deprecate! date: "2025-09-14", because: :unmaintained

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  # Bump `munkres` version to fix error[E0658]: use of unstable library feature `test`
  # Commit ref: https://github.com/git-series/git-series/commit/daf949d8b5b1c9299c49a5cfd30b6da9534ccb87
  patch :DATA

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    # TODO: In the next version after 0.9.1, update this command as follows:
    # system "cargo", "install", *std_cargo_args
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "git-series.1"
  end

  test do
    require "utils/linkage"

    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS

    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "-m", "Initial commit"
    (testpath/"test").append_lines "bar"
    system "git", "commit", "-m", "Second commit", "test"
    system bin/"git-series", "start", "feature"
    system "git", "checkout", "HEAD~1"
    system bin/"git-series", "base", "HEAD"
    system bin/"git-series", "commit", "-a", "-m", "new feature v1"

    linked_libraries = [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"git-series", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end

__END__
diff --git a/Cargo.toml b/Cargo.toml
index a8fb891..2aaacd9 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -14,6 +14,6 @@ clap = "2.7.0"
 colorparse = "2.0"
 git2 = "0.6"
 isatty = "0.1.1"
-munkres = "0.3.0"
+munkres = "0.5"
 quick-error = "1.0"
 tempdir = "0.3.4"
diff --git a/src/main.rs b/src/main.rs
index 623c1f8..48bd2a5 100644
--- a/src/main.rs
+++ b/src/main.rs
@@ -37,6 +37,10 @@ quick_error! {
             cause(err)
             display("{}", err)
         }
+        Munkres(err: munkres::Error) {
+            from()
+            display("{:?}", err)
+        }
         Msg(msg: String) {
             from()
             from(s: &'static str) -> (s.to_string())
@@ -1286,14 +1290,14 @@ fn write_commit_range_diff<W: IoWrite>(out: &mut W, repo: &Repository, colors: &
         }
     }
     let mut weight_matrix = munkres::WeightMatrix::from_row_vec(n, weights);
-    let result = munkres::solve_assignment(&mut weight_matrix);
+    let result = try!(munkres::solve_assignment(&mut weight_matrix));
 
     #[derive(Copy, Clone, Debug, PartialEq, Eq)]
     enum CommitState { Unhandled, Handled, Deleted };
     let mut commits2_from1: Vec<_> = std::iter::repeat(None).take(ncommits2).collect();
     let mut commits1_state: Vec<_> = std::iter::repeat(CommitState::Unhandled).take(ncommits1).collect();
     let mut commit_pairs = Vec::with_capacity(n);
-    for (i1, i2) in result {
+    for munkres::Position { row: i1, column: i2 } in result {
         if i1 < ncommits1 {
             if i2 < ncommits2 {
                 commits2_from1[i2] = Some(i1);
