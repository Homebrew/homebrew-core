class Glyph < Formula
  desc "Converts images/video to ASCII art"
  homepage "https://github.com/seatedro/glyph"
  url "https://github.com/seatedro/glyph/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "e03f14a909d6646c72407c17d8ebe21855525207be638cf8f8178764541377f5"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "zig" => :build
  depends_on "ffmpeg"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *std_zig_args
  end

  test do
    system bin/"glyph", "-i", test_fixtures("test.jpg"), "-o", "out.txt"
    assert_path_exists "out.txt"
  end
end
