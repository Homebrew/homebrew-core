class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  # use tag not tarball so the version in the pkg-config file isn't blank
  url "https://github.com/ccxvii/mujs.git",
      :tag => "1.0.5",
      :revision => "7448a82448aa4eff952a4fdb836f197b844e3d1d"
  head "https://github.com/ccxvii/mujs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d38cb53752b8e8340c8174222a8846f6bcd26b6a2bafd8e765033d514ffeec50" => :mojave
    sha256 "7cf5ff307f83717e15e58e3e8a523291c9b98246410f92aa2cd538665030bd06" => :high_sierra
    sha256 "debcd9dfd3b231be5315035d851bbfa9ca4e7912cbc020a2a972ee30037f3582" => :sierra
  end

  def install
    system "make", "release"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test.js").write <<~EOS
      print('hello, world'.split().reduce(function (sum, char) {
        return sum + char.charCodeAt(0);
      }, 0));
    EOS
    assert_equal "104", shell_output("#{bin}/mujs test.js").chomp
  end
end
