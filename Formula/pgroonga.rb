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
    sha256 cellar: :any, arm64_monterey: "8ad906879e52d252171bd50e210707839cd4538620464d051cb0703db928ed52"
    sha256 cellar: :any, arm64_big_sur:  "65dd73784107571ea9dd801538dd954be12cf5ccf146aab93dcf287ee23584a5"
    sha256 cellar: :any, monterey:       "a3015311bfc84faa410deebdce6565319490799598cd1462d97d1fe1b0ff8e7b"
    sha256 cellar: :any, big_sur:        "a023e004ed5c714c48c4b69762d6a08e25bf0e8dc8fa399f5c18ac26fa9efdff"
    sha256 cellar: :any, catalina:       "6df7b7cc7a2183df42ed32572bb462d701149305e73da7826cb404473209bb39"
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
