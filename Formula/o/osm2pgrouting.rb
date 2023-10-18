class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.8.tar.gz"
  sha256 "e3a58bcacf0c8811e0dcf3cf3791a4a7cc5ea2a901276133eacf227b30fd8355"
  license "GPL-2.0-or-later"
  revision 8
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aab5b11cdd3bb5e4e004ef0da2ec07b0beefff5280c188b51e1c162cb69757e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3fdaf7736e3f57e03ee5ab6deea261ff05e170f762449150c8bee8ea6cca162"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e14af470561defe1a20cf4525a6e40216ee20930ec01ee57f4d41590245450bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66bdaeeb3d7413ffaffe445c9b20ef3476695ef07f2ec5c11c50a0c0d52fd6bd"
    sha256 cellar: :any,                 sonoma:         "11d054eb3a016f01da6ca0987b51bf8039a048bf19ab2f6c739f720b8b5ca061"
    sha256 cellar: :any_skip_relocation, ventura:        "fd4b01a6522b2dab4095605369523d6d91cf6916a76f12cc10ce27a2c9ac96a3"
    sha256 cellar: :any_skip_relocation, monterey:       "c0cf0ba86c28ef807a0f28c5afc68b7ef84efbe1da1c6a08d1ab8d2a6c199495"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc040dc98abdf5ebf358dbc4993c1aa473fcd63b4b59a30814682655815a94e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ff316a52c203ad1d7ce333198f5c77ad0f86e1ef3ac6ab35fb8017496e5f128"
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
