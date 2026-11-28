class Mdds < Formula
  desc "Multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "https://gitlab.com/api/v4/projects/mdds%2Fmdds/packages/generic/source/4.0.0/mdds-4.0.0.tar.bz2"
  sha256 "4b04787c31c706ca1f3bd5a24e186b41f78ce772dfd22feb26737369ef522502"
  license "MIT"
  compatibility_version 1

  bottle do
    manifest_sha256 "bfaa01906698a733544079d90160b5c6ae7f5ebe5be27dda1d64a07a837663aa"
    sha256 cellar: :any_skip_relocation, all: "de3fad33a9f2070d70b2dc0b8c3120241bfa9bd51746aa029452a0e5c99c73e8"
  end

  head do
    url "https://gitlab.com/mdds/mdds.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "boost" => :no_linkage

  deny_network_access!

  def install
    args = ["--disable-openmp"] if OS.mac?
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *args, *std_configure_args
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
                    "-std=c++20",
                    "-I#{include.children.first}"
    system "./test"
  end
end
