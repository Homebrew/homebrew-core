class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "http://dev.mujs.com/"
  # use tag not tarball so the version in the pkg-config file isn't blank
  url "https://github.com/ccxvii/mujs.git",
      :tag => "1.0.3",
      :revision => "25821e6d74fab5fcc200fe5e818362e03e114428"
  head "https://github.com/ccxvii/mujs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb8b7a3337831dff43fe813a1152fe937b2513a8b3ba4c593a2b997b78c35b9b" => :high_sierra
    sha256 "fc943c10b6dc2e8a43ebee1e61ebe2f258c9c4d3a60779dfbc31bebcd5338452" => :sierra
    sha256 "9bbc41eaa943fb9fc3f9500d777a5f1840946359c4c3e24eea58272ad2f1698d" => :el_capitan
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
