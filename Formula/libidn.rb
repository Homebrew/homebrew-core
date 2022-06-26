class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "https://ftp.gnu.org/gnu/libidn/libidn-1.40.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn-1.40.tar.gz"
  sha256 "527f673b8043d7189c056dd478b07af82492ecf118aa3e0ef0dc98c11af79991"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any, arm64_monterey: "225d0f361fda224a4f91744621be1d196501579b4249dc9da3b8a2e1d5520fad"
    sha256 cellar: :any, arm64_big_sur:  "f87b79418fded585630ed8b772b5f43f4d2cf1a3ceff505411511556af36beba"
    sha256 cellar: :any, monterey:       "0027fc47b2b097d477126cab21c098a1eb29b587ef0e9cc63907ba3b16c3016a"
    sha256 cellar: :any, big_sur:        "729a7fa836613b1a98070aa9286021eb9fbbfe6f0483826c6e31c4d3f1e8814a"
    sha256 cellar: :any, catalina:       "305fdbc5c8aba3bef28137bee2cb8f6b8c10d40d8cb028f1ab7772e02da77d41"
    sha256               x86_64_linux:   "ca9fe02b42d2d5b5cd5ec1eebb9e575531d715a5b91d95617eea28f4d3d72e0c"
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-csharp",
                          "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system bin/"idn", "räksmörgås.se", "blåbærgrød.no"
  end
end
