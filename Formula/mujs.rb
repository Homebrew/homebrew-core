class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "http://dev.mujs.com/"
  url "https://github.com/ccxvii/mujs/archive/1.0.1.tar.gz"
  sha256 "04cb21cb83039a9cb8c12c103a9a81a2c85e4d71de5e16665f69edef6a414e4d"
  head "https://github.com/ccxvii/mujs.git"

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
