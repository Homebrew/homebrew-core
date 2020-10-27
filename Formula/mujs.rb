class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  # use tag not tarball so the version in the pkg-config file isn't blank
  url "https://github.com/ccxvii/mujs.git",
      tag:      "1.0.9",
      revision: "6871e5b41c07558b17340f985f2af39717d3ba77"
  license "ISC"
  head "https://github.com/ccxvii/mujs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb7344e1f8e8e407fddc9484dd7392be6c6e7a4b88ca05f912a2028ffd780991" => :catalina
    sha256 "1c945e15f08632584cde81b06d233bf62bcd3fee4bde016cbdb37bb067e85a22" => :mojave
    sha256 "9d94f85a85c383c131a32b31f87548d7a8bd89595227a63470925ce5272b41d8" => :high_sierra
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
