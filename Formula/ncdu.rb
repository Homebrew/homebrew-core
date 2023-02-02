class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-2.2.2.tar.gz"
  sha256 "90d920024e752318b469776ce57e03b3c702d49329ad9825aeeab36c3babf993"
  license "MIT"
  head "https://g.blicky.net/ncdu.git", branch: "zig"

  livecheck do
    url :homepage
    regex(/href=.*?ncdu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "df42cbbe3de7f505f2d12dc32e9a707efe8ae4929d8271863bcc4212d18d8db5"
    sha256 cellar: :any,                 arm64_big_sur:  "9bc784d085749606963a5eb168ea7302f7a4823d0d893c634ece29f78a655e69"
    sha256 cellar: :any,                 monterey:       "d9f2c3dc281847f48eff41da255c5a201a45ca0b807abc901f9bf3d64ad031c1"
    sha256 cellar: :any,                 big_sur:        "6518ea67bbd8867601f3babd06a2b33c3a219784724309cf0b3d17ade9a80bf6"
    sha256 cellar: :any,                 catalina:       "01527e4ef4f29c9986be963cabc63e80cb4d186f02ce383168c4977ee2c92775"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12e5b4ab226138e9ccecff88e414a9fd5031ee7440de9f9f9a178fb4705097b4"
  end

  depends_on "pkg-config" => :build
  depends_on "zig" => :build
  # Without this, `ncdu` is unusable when `TERM=tmux-256color`.
  depends_on "ncurses"

  patch :DATA

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
