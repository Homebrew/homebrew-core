class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v3.2.1/pgrouting-3.2.1.tar.gz"
  sha256 "daeb7ba8703dde9b6cc84129eab64a0f2e1f819f00b9a9168a197c150583a5fd"
  license "GPL-2.0-or-later"
  head "https://github.com/pgRouting/pgrouting.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "03b5237e1971242e2b8af01514943c61d289f9fe8630653c7a99a8f39529c7a4"
    sha256 cellar: :any_skip_relocation, big_sur:       "402d0d183b3246c12fb45c74110a4e9d5607c3681a42f2e47debb2e50e02d2f2"
    sha256 cellar: :any_skip_relocation, catalina:      "369e843e9c3c7eff94c0a94d13694d75c1f9024a9710763fc68c6834cec4d52d"
    sha256 cellar: :any_skip_relocation, mojave:        "f4e8a237208ebf9264a442fa3fc1364d7ffd42cdee769c3206c028fb95975144"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "postgis"
  depends_on "postgresql"

  def install
    mkdir "stage"
    mkdir "build" do
      system "cmake", "-DWITH_DD=ON", "..", *std_cmake_args
      system "make"
      system "make", "install", "DESTDIR=#{buildpath}/stage"
    end

    lib.install Dir["stage/**/lib/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
  end
end
