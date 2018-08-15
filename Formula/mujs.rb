class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  # use tag not tarball so the version in the pkg-config file isn't blank
  url "https://github.com/ccxvii/mujs.git",
      :tag => "1.0.4",
      :revision => "c86267d8b2b5f9a6ae318dc69886109eee0c7b61"
  head "https://github.com/ccxvii/mujs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c962c59672d0b8cd91e2c04bfee730c8e520700aa82aad311afcba915bc68eb2" => :high_sierra
    sha256 "0825935cc4a064502c05e6f177cfc717030a7ca6198537aac1a7fd75bfdeb24f" => :sierra
    sha256 "5376177a24d6ac21859f8c313267b558ab417ee8f3154b96fc3b42b380d3bea6" => :el_capitan
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
