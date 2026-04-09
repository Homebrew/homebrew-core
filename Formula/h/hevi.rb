class Hevi < Formula
  desc "Hex viewer"
  homepage "https://codeberg.org/arnauc/hevi"
  url "https://codeberg.org/arnauc/hevi/archive/v1.1.0.tar.gz"
  sha256 "8ad6a056cd7ae5e3ba52abeffc7e1c45f591266cf5896d8decb7e487a7596db9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76e18798c302421d681fdb0d0cada44b315b40f8e1a931122bc89ca4f658b5ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af71a0d595ed48d139c93e8f4ef5a59edea2309afeddf280c5408ba532d470f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "135aef044ae02eb3898d410284c9ca8e75289effcef3dd15bc56f7a4df50f1e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e9597a6ff6d8eeac1df5ad0bd524a8b2a1998af819df0dc5d2b2ff8f6037a23"
    sha256 cellar: :any_skip_relocation, sonoma:        "c023afee5920d4732b9a9dd8d85e0c2922a877cb51b288901ea93bbb90897b37"
    sha256 cellar: :any_skip_relocation, ventura:       "7ad8ac2263159c788705564b0a17d3f9052f237db3efffcd1e68f089314a4006"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99c83848d5160f04004119a73ffe2a2ba4ad978cc8c5d99d6faccf2f56d1218c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98a58cbce9389c32d13ddf68be6a62b89113000d5ae6f82711174b90cf63174e"
  end

  depends_on "zig" => :build

  # Backport support for Zig 0.14
  patch do
    url "https://github.com/Arnau478/hevi/commit/07847bf8c2f05d02756aea1ffce7dd60ad563daf.patch?full_index=1"
    sha256 "71e992a3183a7fbfa94ac98b12e02fee2f36f4e66b7a60ae78bb699f461edc90"
  end
  patch :DATA # https://github.com/Arnau478/hevi/commit/3ef411b8664c8ac7d8296680b2d494f7193a521d
  patch do
    url "https://github.com/Arnau478/hevi/commit/830ce7fff48429027c6a527b9c9a53935a212e81.patch?full_index=1"
    sha256 "9a78d4e64126c0ddc4c2fa84c0f6a163b8dacd41558df564ca4918c4c3454ea8"
  end

  # Backport support for Zig 0.15
  patch do
    url "https://codeberg.org/arnauc/hevi/commit/810fdf763ccb7069103b8350fab699bb9d3b7b15.diff"
    sha256 "6dff03ca70c27d9f514d541045eeaa1a9fc8e3ac7405329ce58f144b1f8dce88"
  end
  patch do
    url "https://codeberg.org/arnauc/hevi/commit/1e0d70fd6f61b4515f2dbc02ddc214388cf9b5d6.diff"
    sha256 "3c467402c7ac5547081d8cf69eb3a37bcdb9da37441d504b280617749c5e2c4b"
  end
  patch do
    url "https://codeberg.org/arnauc/hevi/commit/6f46f9e6fbcfb7bd331dadbde7f6da48a6679b5c.diff"
    sha256 "8649801251f87c51db9735cafb4eaf14f6c9255c45f0e9dea2a70b7f0f578bf9"
  end

  def install
    # Revert the version update patch
    inreplace "build.zig.zon", '"2.0.0"', "\"#{version}\""

    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else Hardware.oldest_cpu
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args, *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hevi --version 2>&1")
    assert_match "00000000", shell_output("#{bin}/hevi #{test_fixtures("test.pdf")}")
  end
end

__END__
--- a/build.zig.zon
+++ b/build.zig.zon
@@ -1,6 +1,6 @@
 .{
     .name = "hevi",
-    .version = "1.1.0",
+    .version = "2.0.0",
     .dependencies = .{
         .ziggy = .{
             .url = "git+https://github.com/kristoff-it/ziggy#ae30921d8c98970942d3711553aa66ff907482fe",
