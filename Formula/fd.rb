class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v8.0.0.tar.gz"
  sha256 "fba93204c10266317e0981914c630b08e12cd322c75ff2a2e504ff1dce17d557"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0bdb984cbb1a2f5ad31edb64125f92cb7f258f6942f4e6cc8e4a03bf10ac02a7" => :catalina
    sha256 "25bafcd08c49e4efa084e821eb29dec4e1a116b3ba158ab17bd861cb01d16522" => :mojave
    sha256 "a0e40188915c506a58e4ff48e4eec0d636cded72c7d0bb773cc543fecb930830" => :high_sierra
  end

  depends_on "rust" => :build

  # Work around issue with rust/jemalloc on Catalina
  # https://github.com/sharkdp/fd/issues/498
  patch :DATA

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
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
--- a/src/main.rs
+++ b/src/main.rs
@@ -29,11 +29,6 @@ use crate::filter::{SizeFilter, TimeFilter};
 use crate::options::Options;
 use crate::regex_helper::pattern_has_uppercase_char;
 
-// We use jemalloc for performance reasons, see https://github.com/sharkdp/fd/pull/481
-#[cfg(all(not(windows), not(target_env = "musl")))]
-#[global_allocator]
-static ALLOC: jemallocator::Jemalloc = jemallocator::Jemalloc;
-
 fn run() -> Result<ExitCode> {
     let matches = app::build_app().get_matches_from(env::args_os());

