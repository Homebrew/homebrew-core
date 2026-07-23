class Hevi < Formula
  desc "Hex viewer"
  homepage "https://codeberg.org/arnauc/hevi"
  url "https://codeberg.org/arnauc/hevi/archive/v1.1.0.tar.gz"
  sha256 "e236bb43c5eb66a183c0ee6f6d14efbb89f9e9427e23a652a7e3916f8b774aa5"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cba222f5ed2e7041cbf1db8d47708a8586214fd6d7d653f6e7cc61d10f67b34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84edf1a33b439f87ce715488d40ff9fbcd7cfa22dbf7ac98ba1cc6c95445021e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05b8bac7ec8d5ab7d6ae6a42b9460e8d278ebdd97e9e19d1a5894060d345f758"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a8d2a512dd0a08aeeabf0e459c183badbc1f898dfcdc9970294d23e79c6428c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb5b143153711f3be4d0a06b69711b7eb4f28e7832f63ccc8f9f0dcea8c950c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44f56d8a4c69ea5f713988ee35347ea3c4bf6501d8fae4976bdc4ab6a602ddd1"
  end

  depends_on "zig@0.15" => :build

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

    system "zig", "build", *std_zig_args
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
