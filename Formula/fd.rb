class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v7.4.0.tar.gz"
  sha256 "33570ba65e7f8b438746cb92bb9bc4a6030b482a0d50db37c830c4e315877537"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f20d5cb883fcf5796f96429376f3251a51b6bb522070be8ebb514f4b6a462713" => :mojave
    sha256 "fe9e33ff09a46fe7f3e7f25852be70de163c7ebdf9213533bf0bb0c1876bd744" => :high_sierra
    sha256 "4cc2785a526d2a377f2a32d675f5b3b0816044fe16a53cde55703cd610fccbef" => :sierra
  end

  depends_on "rust" => :build

  # Work around issue with rust/jemalloc on Catalina
  # https://github.com/sharkdp/fd/issues/498
  patch :DATA

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "doc/fd.1"
    bash_completion.install "fd.bash"
    fish_completion.install "fd.fish"
    zsh_completion.install "_fd"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
__END__
diff -pur a/Cargo.toml b/Cargo.toml
--- a/Cargo.toml	2019-09-15 19:29:15.000000000 +0200
+++ b/Cargo.toml	2019-10-19 10:14:25.000000000 +0200
@@ -52,9 +52,6 @@ features = ["suggestions", "color", "wra
 [target.'cfg(all(unix, not(target_os = "redox")))'.dependencies]
 libc = "0.2"

-[target.'cfg(all(not(windows), not(target_env = "musl")))'.dependencies]
-jemallocator = "0.3.0"
-
 [dev-dependencies]
 diff = "0.1"
 tempdir = "0.3"
diff -pur a/src/main.rs b/src/main.rs
--- a/src/main.rs	2019-09-15 19:29:15.000000000 +0200
+++ b/src/main.rs	2019-10-19 10:14:39.000000000 +0200
@@ -35,11 +35,6 @@ use crate::internal::{
     pattern_has_uppercase_char, transform_args_with_exec, FileTypes,
 };

-// We use jemalloc for performance reasons, see https://github.com/sharkdp/fd/pull/481
-#[cfg(all(not(windows), not(target_env = "musl")))]
-#[global_allocator]
-static ALLOC: jemallocator::Jemalloc = jemallocator::Jemalloc;
-
 fn main() {
     let checked_args = transform_args_with_exec(env::args_os());
     let matches = app::build_app().get_matches_from(checked_args);
