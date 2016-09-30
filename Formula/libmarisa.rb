class Libmarisa < Formula
  desc "Static and space-efficient trie data structure"
  homepage "https://github.com/s-yata/marisa-trie"
  revision 1

  stable do
    url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/marisa-trie/marisa-0.2.4.tar.gz"
    sha256 "67a7a4f70d3cc7b0a85eb08f10bc3eaf6763419f0c031f278c1f919121729fb3"

    # trie-test.cc:71: TestKey(): 115: Assertion `r_key.ptr() == NULL' failed.
    # Both upstream patches are needed since one unwinds the other.
    patch do
      url "https://github.com/s-yata/marisa-trie/commit/80f812304bcf6d2ca2f7d614cbb7b5fb07ac44f5.patch"
      sha256 "e7882c93b470c1a079ee22805108f976b2a460759ea7656cf5264a793427cc8c"
    end

    patch do
      url "https://github.com/s-yata/marisa-trie/commit/cbab26f05f92313e72f4a58262264879bdb37531.patch"
      sha256 "dfce4e35db5a2b51bdcbc396dfd03cbf1c9b5e2f786548e8001e2af661d4b55c"
    end
  end

  bottle do
    cellar :any
    sha256 "5bcdabfe61983f0913b5a97113949f08fedeb99c993ea4b4af7e90afcdbd9da6" => :sierra
    sha256 "3af0c8f7adf4dd630e29c3d604614e09d40e2c8154cc78c7b184a9b37aad26b1" => :el_capitan
    sha256 "225b53e732cde281f00d281e7e76dcf46243badd448ef84a515b420e84746c48" => :yosemite
    sha256 "a41201761d4ac0a4659137f7064386dacab6584d8a2c61e1de914fcaaa7daf35" => :mavericks
  end

  head do
    url "https://github.com/s-yata/marisa-trie.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Fixes TestEntry(): 212: Assertion `entry.ptr() == NULL' failed.
  # Same method as upstream used for the `r_key.ptr() == NULL' bug
  # Upstream PR opened 7th May 2016
  patch do
    url "https://github.com/s-yata/marisa-trie/pull/9.patch"
    sha256 "35cb5c33083e9780aed45cfddd45ebe6aea28ae1eb2a2014f5f02a48cdbc60a9"
  end

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <marisa.h>
      int main() {
        marisa::Keyset keyset;
        keyset.push_back("a");
        keyset.push_back("app");
        keyset.push_back("apple");

        marisa::Trie trie;
        trie.build(keyset);

        marisa::Agent agent;
        agent.set_query("apple");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-lmarisa", "-o", "test"
    system "./test"
  end
end
