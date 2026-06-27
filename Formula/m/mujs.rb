class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  url "https://mujs.com/downloads/mujs-1.3.9.tar.gz"
  sha256 "956d5a20dd4efe5aa58673558787b9e2539255f9bf62585e90e1921fa040d89d"
  license "ISC"
  compatibility_version 1
  head "https://codeberg.org/ccxvii/mujs.git", branch: "master"

  livecheck do
    url "https://mujs.com/downloads/"
    regex(/href=.*?mujs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2814b3eab41c69484ac739e66bfeaf6bb2f61b7df974c5866e3934844d8acc0b"
    sha256 cellar: :any,                 arm64_sequoia: "0b8f0ef456a43755bc65a729760c2033f581db40b9843ac3247ef6aa79a2ddf5"
    sha256 cellar: :any,                 arm64_sonoma:  "710aff8637dab71ffa1b013c9fe7108d7a14e644a252728674b82fe4d5dc62fb"
    sha256 cellar: :any,                 sonoma:        "d3658e31032b05342d35990a7a4829922ddf5e40bfecd8c39669003bc50b154f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62a937838c05b66d72f159d3bbd0a5f16a9b4132de069cbb07a2f75a610ce202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d65afabe2832997c8b0bac97b58f05a429b4404f726c089476fef68130df1da"
  end

  depends_on "pkgconf" => :test

  on_linux do
    depends_on "readline"
  end

  # update build for `utfdata.h`, upstream pr ref, https://github.com/ccxvii/mujs/pull/203
  patch do
    url "https://github.com/ccxvii/mujs/commit/e21c6bfdce374e19800f2455f45828a90fce39da.patch?full_index=1"
    sha256 "e10de8b9c3a62ffe121b61fe60b67ba8faa68eaace9a3b17a13f46a2cc795a11"
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
