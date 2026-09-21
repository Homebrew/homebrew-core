class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  url "https://mujs.com/downloads/mujs-1.3.10.tar.gz"
  sha256 "6e36c15dbb84ff859320297c900852f241b131a7b6ddaea669ac9a65bd75571c"
  license "ISC"
  compatibility_version 2
  head "https://codeberg.org/ccxvii/mujs.git", branch: "master"

  livecheck do
    url "https://mujs.com/downloads/"
    regex(/href=.*?mujs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f09cd6a5e4c656b9e5ec9d2545d3915ab87a2096bb1b8639af77b58681c49498"
    sha256 cellar: :any, arm64_tahoe:       "a74e150e1d09521e6105a443d5587ac33bf2ca3cac25390125ce6484bd4869b9"
    sha256 cellar: :any, arm64_sequoia:     "94b16a3d68483ee7257762d0ca37b30ba8c4437322047388b03840fe74dba305"
    sha256 cellar: :any, arm64_sonoma:      "80859443a49f4fde57750b0bbfd4c143fe693ae0b4db8120f54ff320dae27baf"
    sha256 cellar: :any, arm64_linux:       "b9acde876f72f8db40e2106fe863a8ed67dea2f789ea3707ae03f1cf0100763d"
    sha256 cellar: :any, x86_64_linux:      "04c0e0954cc1634cfc55c73d4ee4d458a4a0a6a96ea87dfe61070dcba1f5e5f8"
  end

  depends_on "pkgconf" => :test

  on_linux do
    depends_on "readline"
  end

  # update build for `utfdata.h`
  patch do
    url "https://github.com/ccxvii/mujs/commit/e21c6bfdce374e19800f2455f45828a90fce39da.patch?full_index=1"
    sha256 "e10de8b9c3a62ffe121b61fe60b67ba8faa68eaace9a3b17a13f46a2cc795a11"
    type :unofficial
    resolves "https://github.com/ccxvii/mujs/pull/203"
  end

  def install
    system "make", "prefix=#{prefix}", "release"
    system "make", "prefix=#{prefix}", "install"
    system "make", "prefix=#{prefix}", "install-shared" if build.stable?
  end

  test do
    (testpath/"test.js").write <<~JAVASCRIPT
      print('hello, world'.split().reduce(function (sum, char) {
        return sum + char.charCodeAt(0);
      }, 0));
    JAVASCRIPT
    assert_equal "104", shell_output("#{bin}/mujs test.js").chomp
    # test pkg-config setup correctly
    assert_match "-I#{include}", shell_output("pkgconf --cflags mujs")
    assert_match "-L#{lib}", shell_output("pkgconf --libs mujs")
    system "pkgconf", "--atleast-version=#{version}", "mujs"
  end
end
