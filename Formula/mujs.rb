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
    sha256 "09f68847e706681c7a0cd68eefd22e414b865d08adc048488ef3fde18efc3e19" => :high_sierra
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
