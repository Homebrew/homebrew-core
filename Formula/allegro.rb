class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "http://liballeg.org/"

  stable do
  url "http://download.gna.org/allegro/allegro/5.2.0/allegro-5.2.0.tar.gz"
  sha256 "af5a69cd423d05189e92952633f9c0dd0ff3a061d91fbce62fb32c4bd87f9fd7"
  end

  bottle do
    cellar :any
    revision 2
    sha256 "920e11cc6cbb00016fdd6626aae4a051b38bf97ce8702ffdc11fc567f192601f" => :el_capitan
    sha256 "53bd9902195241cdddc873a3c9afa92beab73c234e1e337d376bcb8d4b3fd2c6" => :yosemite
    sha256 "65a04aa3c0901264e54ca91f8982da085ea90bccabcb885fac054ba5219e19bd" => :mavericks
  end

  head do
    url "https://github.com/liballeg/allegro5.git", :branch => "5.2"
  end

  depends_on "cmake" => :build
  depends_on "libvorbis" => :recommended
  depends_on "freetype" => :recommended
  depends_on "flac" => :recommended
  depends_on "physfs" => :recommended
  depends_on "dumb" => :recommended
  depends_on "libogg" => :recommended
  depends_on "theora" => :recommended

  def install
    mkdir "build" do
      system "cmake", "..", "-DWANT_DOCS=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"allegro_test.cpp").write <<-EOS
    #include <assert.h>
    #include <allegro5/allegro5.h>

    int main(int n, char** c) {
      if (!al_init()) {
        return 1;
      }
      return 0;
    }
    EOS

    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lallegro", "-lallegro_main", "-o", "allegro_test", "allegro_test.cpp"
    system "./allegro_test"
  end
end
