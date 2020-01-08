class Libmusicbrainz < Formula
  desc "MusicBrainz Client Library"
  homepage "https://musicbrainz.org/doc/libmusicbrainz"
  url "https://github.com/metabrainz/libmusicbrainz/releases/download/release-5.1.0/libmusicbrainz-5.1.0.tar.gz"
  sha256 "6749259e89bbb273f3f5ad7acdffb7c47a2cf8fcaeab4c4695484cef5f4c6b46"

  bottle do
    cellar :any
    sha256 "3ff30e82e933e84fdaacc2a0d8c568678adfabb0b7771667cbcaf07132f59a14" => :catalina
    sha256 "420d6867aa3d20d9148d4546a154e7059467cc4ca8d861dfb173c9ea35f10dab" => :mojave
    sha256 "99b598b941ac0ce3747d8821943a1e730f3673b721421d9c0428b70259e789c0" => :high_sierra
    sha256 "8fe055e1f987e23a569f915082031e172a5c3d0aef6f86de78ce9c8258f53cd2" => :sierra
    sha256 "6a63410ca9eae84b263d7165d05701801f4e05de26a9e95a7396f95a602cedd7" => :el_capitan
    sha256 "0851c7889df9dc2971b60fe9fd8ad891afd8d5dae08877393e2f69e3cc33f589" => :yosemite
    sha256 "44fa04315d5bbda3e6b9e6ce20a6140c93d535d8c58e8816c574a7e6d4b90429" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "neon"

  def install
    neon = Formula["neon"]
    neon_args = %W[-DNEON_LIBRARIES:FILEPATH=#{neon.lib}/libneon.dylib
                   -DNEON_INCLUDE_DIR:PATH=#{neon.include}/neon]
    system "cmake", ".", *(std_cmake_args + neon_args)
    system "make", "install"
  end
end
