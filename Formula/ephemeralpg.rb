class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "http://ephemeralpg.org"
  url "http://ephemeralpg.org/code/ephemeralpg-2.2.tar.gz"
  mirror "https://bitbucket.org/eradman/ephemeralpg/get/ephemeralpg-2.2.tar.gz"
  sha256 "dfd3df1cd222024439219fe82f2d3e64d0d2fad5e302a4e0c2ff0fc12a5b88ec"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "b965efcfc8f97bc05ebd994cd6bc764999b971f4c617b11a8703bedf1c634514" => :high_sierra
    sha256 "b74184bcf5e26faf500d6381bfc2d933d2a0ebfa5f4a13fb2c109e257d591b4d" => :sierra
    sha256 "2dcbf5709d0242399f79ac4ccf765cbbff0288ab906ff2ad67af3dde482815cd" => :el_capitan
    sha256 "c3061720932617170d09d7812d722607a71c165106bddc9315d8981a05d9ad17" => :yosemite
  end

  depends_on "postgresql"

  def install
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end

  test do
    system "#{bin}/pg_tmp", "selftest"
  end
end
