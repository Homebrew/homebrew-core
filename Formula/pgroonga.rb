class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.3.1.tar.gz"
  sha256 "832c8a0ab4735f207f528abfbac9e686bca09df6190bd9fc96a2e0af1714206c"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "965c4bc5b92d99b8a98c2743248447d0260d2925c7d50c8717255d0502bcd676"
    sha256 cellar: :any, big_sur:       "fe3c58f82c97e7da2c0889b4a3dd3de817fc6c48627970b5aa65d28d208417f5"
    sha256 cellar: :any, catalina:      "7917e151527fb4dbd97ce7788723c25b2612bf6c565c3057d58d3aaec19e0fd7"
    sha256 cellar: :any, mojave:        "31ebc734c68b5fa6f43ff20e8becc7c1b6ba3423445b10127e261a662300b573"
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
