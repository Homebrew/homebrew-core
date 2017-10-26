class Clinfo < Formula
  desc "Print information about OpenCL platforms and devices"
  homepage "https://github.com/Oblomov/clinfo"
  url "https://github.com/Oblomov/clinfo/archive/2.2.17.10.25.tar.gz"
  sha256 "23cab774915eea6730582abfc449ac57dc10f2ce7b39293e56166ed500383862"

  bottle do
    cellar :any_skip_relocation
    sha256 "8cd953b3653b9682e74f3d8cb07b5994492e3ccd85105e46b273211d4d3202c0" => :high_sierra
    sha256 "5912c4cc573b7672fd1c57c3a996a652d859464261e315d3c1cd15bd7d0960f1" => :sierra
    sha256 "0628536ac3c1aa999c8edc1f2acbdf905364763bb541d00fcfca099f7c471fe6" => :el_capitan
    sha256 "d5595d26f35a9f6ea035686dc16b90ef8e4151f91c266755c0ce3f6e1729f968" => :yosemite
  end

  def install
    system "make", "MANDIR=#{man}", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match /Device Type +CPU/, shell_output(bin/"clinfo")
  end
end
