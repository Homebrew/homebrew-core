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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "01bb1d3dcbec16e438b1dc1491a47b5b8068d4638bbe77e4d23c2abc01ea7c75"
    sha256 cellar: :any_skip_relocation, big_sur:       "cb2de38ec47a64ffeb7bf1fab3caf7e7936af672f13c1c26bf9911e25107888e"
    sha256 cellar: :any_skip_relocation, catalina:      "3d8f445a2559cd5aaa03f4b2f082681ad2243ba42d339962f2a8967376e0e1af"
    sha256 cellar: :any_skip_relocation, mojave:        "1f748c85da5b08ae3c7ceee5ff202a84ec2103fe578ce285f642c116800178f5"
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
