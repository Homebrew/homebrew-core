class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2026/sqlite-src-3510300.zip"
  version "3.51.3"
  sha256 "f8a67a1f5b5cae7c6d42f0994ca7bf1a4a5858868c82adc9fc1340bed5eb8cd2"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2150ccd67f5a29b7a030e2d8d484fdeb97485d4849ac204204d5efbd0ca13bc1"
    sha256 cellar: :any,                 arm64_sequoia: "ffb9131e77844bebb5c1a0daf2de80a0403eca839421f58ecf1239d60d8f47ba"
    sha256 cellar: :any,                 arm64_sonoma:  "43d46d9459aacc82f1dc3b0771e4c058840354f918704bcdae72be8726cc8c57"
    sha256 cellar: :any,                 tahoe:         "dd84508af10810f3dfa67331478a4645b8b1a326134993070f8c010542229606"
    sha256 cellar: :any,                 sequoia:       "7bd5cd638c06d4e61998d6ccf744e0f180b8c3bc22411daebf1fcfb77c203273"
    sha256 cellar: :any,                 sonoma:        "61286f274f9a4feb9f468073bdf709df1c46f1786b43f60dceb25422726edde7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22de2a1351c5935a9889f7d6a1a88fa769c64a01641854a47cca745305da049c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d55ac3b98be9e1db5d85b9d0a89c2db9b58f4cad2a702a1766d7247dde330eb"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "dbhash"
    bin.install "dbhash"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "b6113e0ce62c5f5ca5c9f229393345ce812b7309",
                 shell_output("#{bin}/dbhash #{dbpath}").strip.split.first
  end
end
