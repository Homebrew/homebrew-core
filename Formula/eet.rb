class Eet < Formula
  desc "Library for writing arbitrary chunks of data to a file using compression"
  homepage "https://docs.enlightenment.org/auto/eet/eet_main.html"
  url "https://download.enlightenment.org/releases/eet-1.7.10.tar.gz"
  sha256 "c424821eb8ba09884d3011207b1ecec826bc45a36969cd4978b78f298daae1ee"

  bottle do
    revision 1
    sha256 "3225daff43da12db5b74c31c1e200a2091f74b9003bdc182d6c45c1b0d1a6fb9" => :el_capitan
    sha256 "94691d413c2d34f9ffa33876406d30aef94f94e955ad6b2e77779329fd59cdb8" => :yosemite
    sha256 "dc57f44fd30a52b8545dbde8c335a672a485071725f4a65037bb4b3273c55d92" => :mavericks
  end

  conflicts_with "efl", :because => "efl aggregates formerly distinct libs, one of which is eet"

  head do
    url "https://git.enlightenment.org/legacy/eet.git/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "eina"
  depends_on "jpeg"
  depends_on "lzlib"
  depends_on "openssl"

  conflicts_with "efl", :because => "both install `eet` binaries"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    cp "#{pkgshare}/examples/eet-basic.c", testpath
    eina = Formula["eina"]
    system ENV.cc, "-o", "eet-basic", "eet-basic.c",
        "-I#{include}/eet-1",
        "-I#{eina.include}/eina-1",
        "-I#{eina.include}/eina-1/eina",
        "-L#{lib}",
        "-leet"
    system "./eet-basic"
  end
end
