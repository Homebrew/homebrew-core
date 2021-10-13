class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.3.2.tar.gz"
  sha256 "7e2744c4f72b2208c90aaa35f251e1702c078ba81dff81b705e139d67b193283"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "31e87e5383f745130c72470927ce55d33a0a431db59e319b342e56a4135e554e"
    sha256 cellar: :any, big_sur:       "19b6bad62b3ede9ecef955ecc833cd0d22607b4686790814e0dc9262deb9cef0"
    sha256 cellar: :any, catalina:      "de178482d102009c256d573adfab721d8154644c66fde6616823c46831dc2079"
    sha256 cellar: :any, mojave:        "234fcf475e296d1b74a5973586cb2a848e1b89c958c928f86e8ab56c8c357630"
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
