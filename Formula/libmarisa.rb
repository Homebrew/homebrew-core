class Libmarisa < Formula
  desc "Static and space-efficient trie data structure"
  homepage "https://code.google.com/p/marisa-trie/"
  url "https://marisa-trie.googlecode.com/files/marisa-0.2.4.tar.gz"
  sha256 "67a7a4f70d3cc7b0a85eb08f10bc3eaf6763419f0c031f278c1f919121729fb3"

  bottle do
    cellar :any
    revision 2
    sha256 "8a02695ab5e2d3417f3ca03b7639ef97de7d58aa72a4268c05620b0af681058b" => :yosemite
    sha256 "b7d7691ab312b816b016a954f2e00106616870d388d2ccef5df68180bcaf30ef" => :mavericks
  end

  def install
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
