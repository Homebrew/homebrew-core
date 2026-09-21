class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "3d3042aa0dd30930d27801c9833ebfbe16eba0ab0e5d6277636ce17b157f2a0f"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "a11f518deb6602c82ec60eaa826ad59270aaeacb5e1feb603d4d7abe9411ab19"
    sha256 cellar: :any, arm64_tahoe:       "81afca2457eaf617b3bebeed932e4f6e1c28cc427097fc26017f5941081cd31f"
    sha256 cellar: :any, arm64_sequoia:     "8f1f0ffca4049b7768e8679c7e13d6f38c77fdad7c066e0145c5c07fd9116681"
    sha256 cellar: :any, arm64_sonoma:      "c355361a3da50f8aabd4b3de1c350983c84c816de7532d7406e7e551a441b365"
    sha256 cellar: :any, arm64_linux:       "3855fb9464d90faee02f1c962cf08f488209c4d5859e1da94db0149658500a86"
    sha256 cellar: :any, x86_64_linux:      "1e21505d58d2adff2e53d2ade5f46aa1aea878d5d4e1ca62a22322693bae49e8"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"

  uses_from_macos "expat", since: :sequoia

  # Support newer libpqxx
  patch do
    url "https://github.com/pgRouting/osm2pgrouting/commit/7622f12b7e6d9e290315609503d090534c2c7df8.patch?full_index=1"
    sha256 "1ce55a33162d7784443d3fb14f8f2238a8080c1dd5af25a6af7d75a2a4770708"
    type :unofficial
    resolves "https://github.com/pgRouting/osm2pgrouting/pull/328"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"osm2pgrouting", "--help"
  end
end
