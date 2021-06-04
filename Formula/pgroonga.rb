class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.3.0.tar.gz"
  sha256 "5b3c8f42989120c8954a03f9d78cdcf017e1bc655f8331a21bc79ecd3927b5f1"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2e95e981c0aabc1cb8c22c53a3406875e139a5d0b79b1eafd140f00a92a93b10"
    sha256 cellar: :any, big_sur:       "7523abcf369c44656da89b4e9a8fde7ad6ef13bc11aa603f09ee17bcc80b3841"
    sha256 cellar: :any, catalina:      "7726ee1b60340628e9ece2b51e7fc729416d357a14c66d8fe940e549c43724a2"
    sha256 cellar: :any, mojave:        "d9ccfa8b66faac85e3638f12990b9620e2a19dfff2c352959f49e3be89827478"
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
