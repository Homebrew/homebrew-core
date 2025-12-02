class Libwbxml < Formula
  desc "Library and tools to parse and encode WBXML documents"
  homepage "https://github.com/libwbxml/libwbxml"
  url "https://github.com/libwbxml/libwbxml/archive/refs/tags/libwbxml-0.11.10.tar.gz"
  sha256 "027b77ab7c06458b73cbcf1f06f9cf73b65acdbb2ac170b234c1d736069acae4"
  license "LGPL-2.1-or-later"
  head "https://github.com/libwbxml/libwbxml.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b4077cb6043d9751ab422e9591a708f7f698389c9b036062fe153a61d50f78e4"
    sha256 cellar: :any,                 arm64_sequoia:  "07916c39f4553dd58011f13bf93e38769b5e4995a7622b98fde568fbf77a0424"
    sha256 cellar: :any,                 arm64_sonoma:   "eec64b623fdf01ee3124f51673a09730bc15cd60c190d056319ae0a52d998516"
    sha256 cellar: :any,                 arm64_ventura:  "f3406dd887132a07e67da3066e036c712d7594b8ba8cba43b072a66b87196714"
    sha256 cellar: :any,                 arm64_monterey: "3e05f1f285a6f28cc3e1840b18badd6874d04e605a4d365fabe034e99d1496ae"
    sha256 cellar: :any,                 sonoma:         "f1254abc997a20ba1365b0338224547b22d0fa70e96be10533d1f73ecb1434cb"
    sha256 cellar: :any,                 ventura:        "574ee31b76288b7d5d76eeeafeca1463b022e1d6764b2c7b9998703db1537468"
    sha256 cellar: :any,                 monterey:       "21c569684b6cf9018b4128fa8bf110d2b693a4eaabcf7edbfe478fccbef0ebf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "af31f53d8ca7525e40d6c8a76cf803a66fd75a54b0a5e4c1a32d3e3ce581efd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6730a5a4348d5bddee6e064cd3728d5753986631dec4299cc93270da7d84645c"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "pkgconf" => :build
  depends_on "wget"

  uses_from_macos "expat"

  def install
    args = %W[
      -DBUILD_DOCUMENTATION=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"input.xml").write <<~XML
      <?xml version="1.0"?>
      <!DOCTYPE sl PUBLIC "-//WAPFORUM//DTD SL 1.0//EN" "http://www.wapforum.org/DTD/sl.dtd">
      <sl href="http://www.xyz.com/ppaid/123/abc.wml"></sl>
    XML

    system bin/"xml2wbxml", "-o", "output.wbxml", "input.xml"
    assert_path_exists testpath/"output.wbxml"
  end
end
