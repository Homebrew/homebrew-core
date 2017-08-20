class Clinfo < Formula
  desc "Print information about OpenCL platforms and devices"
  homepage "https://github.com/Oblomov/clinfo"
  url "https://github.com/Oblomov/clinfo/archive/2.2.17.06.14.tar.gz"
  sha256 "6179a92bbe1893b7c5b1dff7c8eaba277c194870d17039addf2d389cbb68b87e"

  def install
    system "make"

    # No "make install" https://github.com/Oblomov/clinfo/issues/23
    bin.install "clinfo"
    man1.install "man/clinfo.1"
  end

  test do
    assert_match /Device Type +CPU/, shell_output(bin/"clinfo")
  end
end
