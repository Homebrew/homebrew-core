class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "http://dev.mujs.com/"
  url "https://github.com/ccxvii/mujs/archive/1.0.1.tar.gz"
  sha256 "04cb21cb83039a9cb8c12c103a9a81a2c85e4d71de5e16665f69edef6a414e4d"
  head "https://github.com/ccxvii/mujs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc90be76e788a0562d3b6802867fdc87fa8f31b6c2d36ccacaeca92930b09a9c" => :sierra
    sha256 "c244f1fe33371356d48794e6e82b920488cc9655a79b35f301c8e71254c6dbed" => :el_capitan
    sha256 "f6a202784d9e03a4ac7c255fa6f60cded4119cef179ded5832d81b8efea202e0" => :yosemite
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
