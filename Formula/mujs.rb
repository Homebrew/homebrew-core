class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "http://dev.mujs.com/"
  # use tag not tarball so the version in the pkg-config file isn't blank
  url "https://github.com/ccxvii/mujs.git",
      :tag => "1.0.1",
      :revision => "4792d16f17b15a1eca3c2a9c856dc13fda1d23c5"
  revision 1
  head "https://github.com/ccxvii/mujs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "57916969b297fa3afa5f05bb97ab42debb6a7214bd1541d3d01001c198f17796" => :high_sierra
    sha256 "469aadeb58ef4fc9c79ef047ea8632ab0824361d28ec6bb0059416e99a724c0a" => :sierra
    sha256 "1e38c739d7f9823fd5c4aa901eee9896d04493679f0871fec83e3ed5a3f3251e" => :el_capitan
  end

  def install
    system "make", "release"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test.js").write <<-EOS
      print('hello, world'.split().reduce(function (sum, char) {
        return sum + char.charCodeAt(0);
      }, 0));
    EOS
    assert_equal "104", shell_output("#{bin}/mujs test.js").chomp
  end
end
