class Etl < Formula
  desc "Extensible Template Library"
  homepage "https://synfig.org"
  # NOTE: Please keep these values in sync with synfig.rb when updating.
  url "https://downloads.sourceforge.net/project/synfig/releases/1.4.2/ETL-1.4.2.tar.gz"
  mirror "https://github.com/synfig/synfig/releases/download/v1.4.2/ETL-1.4.2.tar.gz"
  sha256 "e54192d284df16305ddfdfcc5bdfe93e139e6db5bc283dd4bab2413ebbead7c7"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/releases/.+?/ETL[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e4ddce5b48c3102446302318b8d19895fc4ed310da33f5dcdbf70308daf197cb"
  end

  depends_on "pkg-config" => :build
  depends_on "glibmm@2.66"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ETL/misc>
      int main(int argc, char *argv[])
      {
        int rv = etl::ceil_to_int(5.5);
        return 6 - rv;
      }
    EOS
    flags = %W[
      -I#{include}/ETL
      -lpthread
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
