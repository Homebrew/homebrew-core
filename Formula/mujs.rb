class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "http://dev.mujs.com/"
  # use tag not tarball so the version in the pkg-config file isn't blank
  url "https://github.com/ccxvii/mujs.git",
      :tag => "1.0.2",
      :revision => "2cb57c6e7188a8438c58e1e3fc452b7ad06bee33"
  head "https://github.com/ccxvii/mujs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "626374af292ec4ea2b31b6deadcda1604e31f0a8c827b16a621a44258a2a4098" => :high_sierra
    sha256 "aae5886954d24c0dfa35f2a1802cdccd3afa37f368181e92f12d7e7009af5ab8" => :sierra
    sha256 "e001713a3180f685919fe453748eabcc9560d4aa8fcba5058948ac0306909f6c" => :el_capitan
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
