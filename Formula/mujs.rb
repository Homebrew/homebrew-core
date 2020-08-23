class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  # use tag not tarball so the version in the pkg-config file isn't blank
  url "https://github.com/ccxvii/mujs.git",
      tag:      "1.0.7",
      revision: "90aca80865e28a1b9be9bc5ef1118438f62e4f8f"
  license "ISC"
  head "https://github.com/ccxvii/mujs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "876610c369e104a1245828afa6578d717b3214ff472ccf4d29e03b38a1adf98e" => :catalina
    sha256 "8c52be2a15fc45f4cbf0aba09c672e12afb9e6d6ae676b97fa7ae17454fb9c10" => :mojave
    sha256 "c72f3e89f750198a8e3432043dbb67a40895126e248536babeff9ecd8628e843" => :high_sierra
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
