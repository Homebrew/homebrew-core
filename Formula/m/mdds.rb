class Mdds < Formula
  desc "Multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "https://gitlab.com/api/v4/projects/mdds%2Fmdds/packages/generic/source/3.2.0/mdds-3.2.0.tar.bz2"
  sha256 "26798ad26aa5f91f2e1270340536c24f75da9b76327a118055cde8ae6eb9a425"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "54cb5905d75aa05f07f70fd4692c00beea33545ef4863484aee1fc8403fd59c6"
  end

  head do
    url "https://gitlab.com/mdds/mdds.git", branch: "master"

    depends_on "automake" => :build
  end

  depends_on "autoconf" => :build
  depends_on "boost"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-openmp
    ]

    # Gets it to work when the CLT is installed
    inreplace "configure.ac", "$CPPFLAGS -I/usr/include -I/usr/local/include",
                              "$CPPFLAGS -I/usr/local/include"

    if build.head?
      system "./autogen.sh", *args
    else
      system "autoconf"
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <mdds/flat_segment_tree.hpp>
      int main() {
        mdds::flat_segment_tree<unsigned, unsigned> fst(0, 4, 8);
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-std=c++17",
                    "-I#{include.children.first}"
    system "./test"
  end
end
