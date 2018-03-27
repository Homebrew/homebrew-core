class Clinfo < Formula
  desc "Print information about OpenCL platforms and devices"
  homepage "https://github.com/Oblomov/clinfo"
  url "https://github.com/Oblomov/clinfo/archive/2.2.18.03.26.tar.gz"
  sha256 "64b02e68ccff3b95437bd0bd70dcb88438c58adec16a7145a5d4e5c26a898ccf"

  bottle do
    cellar :any_skip_relocation
    sha256 "be59d0edfcd1c5562f592fc3fef2a7fa07458b8bebc0aee775a9a5ae7990f89f" => :high_sierra
    sha256 "26cfead23b4212039715c0f113e4317be6f79a34abcd30c485a1d89dc14eb25e" => :sierra
    sha256 "2469534819c232ffc83c0e3d09db5d08ec20d8a6e1cc1427f41050aa467d9b1f" => :el_capitan
  end

  def install
    system "make", "MANDIR=#{man}", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match /Device Type +CPU/, shell_output(bin/"clinfo")
  end
end
