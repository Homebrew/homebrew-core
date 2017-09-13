class Clinfo < Formula
  desc "Print information about OpenCL platforms and devices"
  homepage "https://github.com/Oblomov/clinfo"
  url "https://github.com/Oblomov/clinfo/archive/2.2.17.08.25.tar.gz"
  sha256 "8e25c8f26ee0c7a3a4a34d2153c7af786b8e0c1d035a2d428b102333e3c1873b"

  bottle do
    cellar :any_skip_relocation
    sha256 "5912c4cc573b7672fd1c57c3a996a652d859464261e315d3c1cd15bd7d0960f1" => :sierra
    sha256 "0628536ac3c1aa999c8edc1f2acbdf905364763bb541d00fcfca099f7c471fe6" => :el_capitan
    sha256 "d5595d26f35a9f6ea035686dc16b90ef8e4151f91c266755c0ce3f6e1729f968" => :yosemite
  end

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
