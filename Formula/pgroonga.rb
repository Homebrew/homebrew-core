class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.3.4.tar.gz"
  sha256 "5c4ebaf4a7c71326394e084c502d06708a9d3d3b1d02cd38a40fedf3893e8b61"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "fce5a76d85b0121371047c86ed1d2d1609164222516a13600c347ab7e2354840"
    sha256 cellar: :any, arm64_big_sur:  "31e87e5383f745130c72470927ce55d33a0a431db59e319b342e56a4135e554e"
    sha256 cellar: :any, monterey:       "52419f1d6e5605b0faa2dffbf0ab8732b8b837cc88b67f706affd53dd53a51e8"
    sha256 cellar: :any, big_sur:        "19b6bad62b3ede9ecef955ecc833cd0d22607b4686790814e0dc9262deb9cef0"
    sha256 cellar: :any, catalina:       "de178482d102009c256d573adfab721d8154644c66fde6616823c46831dc2079"
    sha256 cellar: :any, mojave:         "234fcf475e296d1b74a5973586cb2a848e1b89c958c928f86e8ab56c8c357630"
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
