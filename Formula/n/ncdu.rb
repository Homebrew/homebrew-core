class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  license "MIT"
  head "https://g.blicky.net/ncdu.git", branch: "zig"

  # Remove `stable` block when the patch is no longer needed.
  stable do
    url "https://dev.yorhel.nl/download/ncdu-2.3.tar.gz"
    sha256 "bbce1d1c70f1247671be4ea2135d8c52cd29a708af5ed62cecda7dc6a8000a3c"

    # Enable install_name rewriting when bottling.
    # Remove in next release.
    # https://code.blicky.net/yorhel/ncdu/commit/07a13d9c7397c3341f430e1127e7287fe53ba8b9
    patch :DATA
  end

  livecheck do
    url :homepage
    regex(/href=.*?ncdu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "6e33f53d26ed222046069f2adcfb1085d8b9a554b1d95150554fb5663d70cac0"
    sha256 cellar: :any, arm64_monterey: "407ef3a5dc0b76d04b42480ab24fb708d0316043f322079621c73e67ccd3bd54"
    sha256 cellar: :any, arm64_big_sur:  "3489200d1a842fb13e09c41c3b4aee3a23efa495be76769f4217b3c2ed042e2f"
    sha256 cellar: :any, ventura:        "bceb9e170df5981294a320a027299278b1f5921fb0329b1b52b841014be3856f"
    sha256 cellar: :any, monterey:       "4719611c107098d06107643b57105c7fc4a9b65a478a9bd5de554e814f38a17a"
    sha256 cellar: :any, big_sur:        "eb5904a48c0e57d42b9149f95f0fa6ac455d1cee24c19eb05aad4405b61da9a8"
    sha256               x86_64_linux:   "85a0bf75cf77e3bca24b48653e71603c798c7d8a39195406a6351c2dfbe58e26"
  end

  depends_on "pkg-config" => :build
  depends_on "zig" => :build
  # Without this, `ncdu` is unusable when `TERM=tmux-256color`.
  depends_on "ncurses"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[--prefix #{prefix} -Drelease-fast=true]
    args << "-Dcpu=#{cpu}" if build.bottle?

    # Avoid the Makefile for now so that we can pass `-Dcpu` to `zig build`.
    # https://code.blicky.net/yorhel/ncdu/issues/185
    system "zig", "build", *args
    man1.install "ncdu.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncdu -v")
    system bin/"ncdu", "-o", "test"
    output = JSON.parse((testpath/"test").read)
    assert_equal "ncdu", output[2]["progname"]
    assert_equal version.to_s, output[2]["progver"]
    assert_equal Pathname.pwd.size, output[3][0]["asize"]
  end
end

__END__
diff --git a/build.zig b/build.zig
index 45bd314..aac1b54 100644
--- a/build.zig
+++ b/build.zig
@@ -10,6 +10,10 @@ pub fn build(b: *std.build.Builder) void {
     const exe = b.addExecutable("ncdu", "src/main.zig");
     exe.setTarget(target);
     exe.setBuildMode(mode);
+    if (exe.target.isDarwin()) {
+        // useful for package maintainers
+        exe.headerpad_max_install_names = true;
+    }
     exe.addCSourceFile("src/ncurses_refs.c", &[_][]const u8{});
     exe.linkLibC();
     exe.linkSystemLibrary("ncursesw");
