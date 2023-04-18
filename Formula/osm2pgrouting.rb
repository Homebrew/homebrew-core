class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.8.tar.gz"
  sha256 "e3a58bcacf0c8811e0dcf3cf3791a4a7cc5ea2a901276133eacf227b30fd8355"
  license "GPL-2.0-or-later"
  revision 6
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "56af11c330b18bf6db24e5259c328646de32653baab8ebace0ee873e4116ce73"
    sha256 cellar: :any,                 arm64_monterey: "b54bd968d45831d73895bb13ef329f7aca352a3b803a18e179f90e2d9fd1be07"
    sha256 cellar: :any,                 arm64_big_sur:  "21270596b8ae2a1f01a192f01ef635660c0fdbd7e82855cdd2f5d230f48639e9"
    sha256 cellar: :any,                 ventura:        "4ae6f5a6d1e8114b5aed18c8567284263e618d8aaab59de9d17db4ed91d423f2"
    sha256 cellar: :any,                 monterey:       "6d593e26efa5ca93d3bbe3d44d64aaca090cfac6ff5d7ce5b13aebe8ffd4d709"
    sha256 cellar: :any,                 big_sur:        "10121e0aaef9ac87c590a2b975cc968fd21132c1ae81274dad5f0425e5383dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a82a9cf69024aa3c8ce857275d2b5258d74397bdad115f567f267205a0e094cf"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "expat"
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"osm2pgrouting", "--help"
  end
end
