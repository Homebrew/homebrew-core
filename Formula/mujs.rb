class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  # use tag not tarball so the version in the pkg-config file isn't blank
  url "https://github.com/ccxvii/mujs.git",
      tag:      "1.0.9",
      revision: "6871e5b41c07558b17340f985f2af39717d3ba77"
  license "ISC"
  revision 1
  head "https://github.com/ccxvii/mujs.git"

  bottle do
    cellar :any
    sha256 "352e5c6c8ad24b3f36ad44e1b929e6f34a00360e5144a4fd490b228e2c9837bb" => :big_sur
    sha256 "b346f30e520540c9bf22be4438ea215ef7954eaf85c66ba71f4fc7be0f5c7f1d" => :arm64_big_sur
    sha256 "f0392da52d7b94279981010c643dc106946cb6a669e1cdb4de03f4732d260341" => :catalina
    sha256 "138027da2db61c148fb93d5176717c10265467551ec5762163d9b7017614c774" => :mojave
  end

  def install
    system "make", "release"
    system "make", "prefix=#{prefix}", "install"
    system "make", "prefix=#{prefix}", "install-shared"
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
