class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.2.9.tar.gz"
  sha256 "f65978fa843cb1a5fb82e72531b88fae481e428930163c06a281e02c0140e3b7"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f84cd3fa23db438daef8669eee46b9db2c1745045ebdc06d979af0b8a4c9c52d"
    sha256 cellar: :any, big_sur:       "af4e6e0a84229ec29bd1abd51ea0645b8d3ec78016645a80ca19cd45fcb7b6c1"
    sha256 cellar: :any, catalina:      "9724e03d9f2f70d5c8b12ea9abf53d7031db907001a355228453437e8dbecd02"
    sha256 cellar: :any, mojave:        "3462b4008436bc2d05602cdf4cac125cfc78dbb7405110cf05f780c249fe4b19"
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
