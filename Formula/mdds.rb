class Mdds < Formula
  desc "Multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "https://kohei.us/files/mdds/src/mdds-1.4.3.tar.bz2"
  sha256 "25ce3d5af9f6609e1de05bb22b2316e57b74a72a5b686fbb2da199da72349c81"

  bottle do
    cellar :any_skip_relocation
    sha256 "5707c206606cdb5020ae0a2a096396e1bec98e569c7b6316cc8031877a3af038" => :mojave
    sha256 "5707c206606cdb5020ae0a2a096396e1bec98e569c7b6316cc8031877a3af038" => :high_sierra
    sha256 "97bf21c72c5c248112b363f8f95b908b8bafcf3b178fefa22652bfde440f82d5" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "boost"

  def install
    # Gets it to work when the CLT is installed
    inreplace "configure.ac", "$CPPFLAGS -I/usr/include -I/usr/local/include",
                              "$CPPFLAGS -I/usr/local/include"
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mdds/flat_segment_tree.hpp>
      int main() {
        mdds::flat_segment_tree<unsigned, unsigned> fst(0, 4, 8);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-std=c++11",
                    "-I#{include.children.first}"
    system "./test"
  end
end
