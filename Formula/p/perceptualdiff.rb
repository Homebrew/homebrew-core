class Perceptualdiff < Formula
  desc "Perceptual image comparison tool"
  homepage "https://pdiff.sourceforge.net/"
  url "https://github.com/myint/perceptualdiff/archive/refs/tags/v2.1.tar.gz"
  sha256 "0dea51046601e4d23dc45a3ec342f1a305baf3bf3328e9ccdae115fe1942f041"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "03e7c420c4d2142cbec50a5ff677801f9a2ffef94cfdcb96715cfd88eca62667"
    sha256 cellar: :any,                 arm64_sequoia: "69f5e86989148e15fdca126111c1070bb23777eabadd346f8e735b6cedc86f5a"
    sha256 cellar: :any,                 arm64_sonoma:  "da4677947b68eca55af42a10d556324578763cb94a71cc14afaccdc3ddf99bf3"
    sha256 cellar: :any,                 arm64_ventura: "0499b71de1b661a7c68f28c343c1fe1175dfb2cfe28b70d6fb6b27393a8613a6"
    sha256 cellar: :any,                 sonoma:        "35f5e8523401d29ed1728df2d4e23c477e441418023d52b7ab03023e81faeeb2"
    sha256 cellar: :any,                 ventura:       "1d88590df41a1619ce9c7f4b29a534179b0bd6d18d7aa296d50da6c4e0101e44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a32ccce208ebcb91041bdf8d2508618a5e1b671ea9fccd5f16c9bc8b2015303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d9a1e10f07e3467e60a855f18c75a07fee4c238d746dc0b91652c147733e9c8"
  end

  depends_on "cmake" => :build
  depends_on "freeimage"

  def install
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    test_tiff = test_fixtures("test.tiff")
    test_png = test_fixtures("test.png")

    # Comparing an image against itself should give no diff
    identical = shell_output("#{bin}/perceptualdiff #{test_tiff} #{test_tiff} 2>&1")
    assert_empty identical

    different = shell_output("#{bin}/perceptualdiff #{test_png} #{test_tiff} 2>&1", 1)
    assert_equal "FAIL: Image dimensions do not match", different.strip
  end
end
