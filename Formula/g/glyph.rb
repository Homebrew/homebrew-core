class Glyph < Formula
  desc "Converts images/video to ASCII art"
  homepage "https://github.com/seatedro/glyph"
  url "https://github.com/seatedro/glyph/archive/refs/tags/v1.0.11.tar.gz"
  sha256 "7de7936a13b92b18240134bef64c006ab73988850a8776a1b276e22b73377f15"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "fcddc6c86d264cdd659ebbfedc657e38928226f4d5aa4bf287093e063c545c0f"
    sha256 cellar: :any,                 arm64_sequoia: "d08bfccc02c09b9799d646e37993f36e8c3361db5f07847ddb46a051460bd9d6"
    sha256 cellar: :any,                 arm64_sonoma:  "1023ab2fe863ebe3d7363f38721ea896612dbf08366ae02d10c9eeaa080974de"
    sha256 cellar: :any,                 arm64_ventura: "e31e144ff58e79196da8eded25d0e0b926e8c9aa13f7da01986d9c92200d3e1a"
    sha256 cellar: :any,                 sonoma:        "595e69055e97fcc3f70b3f6f4cfa5debf4bc5656c4848432a5a018b8f980c90a"
    sha256 cellar: :any,                 ventura:       "45efa20e2e08853b1dce7d98fd30833d617f21da61bbb9d20630a1540c147b38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee2ef8a524e652aa28de614334a435e07092b963451557b327a2921ac41239b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca9382a91b01f87a5d3cf815c5ad87345fb2ac18e4fd698d224f194ea420b9ee"
  end

  # Aligned to `zig@0.14` formula. Can be removed if upstream updates to newer Zig.
  deprecate! date: "2026-02-19", because: "does not build with Zig >= 0.15"

  depends_on "pkgconf" => :build
  depends_on "zig@0.14" => :build # https://github.com/seatedro/glyph/issues/32
  depends_on "ffmpeg"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args, *std_zig_args
  end

  test do
    system bin/"glyph", "-i", test_fixtures("test.png"), "-o", "png.txt"
    assert_path_exists "png.txt"

    system bin/"glyph", "-i", test_fixtures("test.jpg"), "-o", "jpg.txt"
    assert_path_exists "jpg.txt"
  end
end
