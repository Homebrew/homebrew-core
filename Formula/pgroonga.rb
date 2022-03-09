class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.3.5.tar.gz"
  sha256 "02ec3d7414b6255be7b09334d0f09f2de0e5d4cf8739825109b0f406ba3a7658"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "2ad9ea45831ae3ffac67788c2a2d72b0be9bfd6c9214b0e2e725060bb4bb203a"
    sha256 cellar: :any, arm64_big_sur:  "a53e679d4d9c3e982ee1317fc721bc79c07197059854f4c230be316ad47cc02a"
    sha256 cellar: :any, monterey:       "84d2e269d422f9e2038f90b176c9a34c80533467f79f7f6961413d9ee7142a4b"
    sha256 cellar: :any, big_sur:        "3b5fff0d0bc8e26d42b1cfbfae8510735bcf1d2ad5c87cb367c12be1c774b450"
    sha256 cellar: :any, catalina:       "08050d1ffe39254ee2d27b5cdf61abc31c924ef4b8f335664b39d3f1fdfc3b5b"
  end

  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "postgresql"

  def install
    system "make"
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    lib.install Dir["stage/**/lib/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
  end
end
