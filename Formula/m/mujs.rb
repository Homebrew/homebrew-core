class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  url "https://mujs.com/downloads/mujs-1.3.4.tar.gz"
  sha256 "c015475880f6a382e706169c94371a7dd6cc22078832f6e0865af8289c2ef42b"
  license "ISC"
  head "https://github.com/ccxvii/mujs.git", branch: "master"

  livecheck do
    url "https://mujs.com/downloads/"
    regex(/href=.*?mujs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f5ada5602ebe7d4ac89f135c4d98ae8e838fb05a887d88520082e73df320c4a8"
    sha256 cellar: :any,                 arm64_ventura:  "23a1b346a1518d43d6542e614afbac3d9dbd5a2ef780852d407144529a99197c"
    sha256 cellar: :any,                 arm64_monterey: "f07d6bb5d0c7f45457686bd9fb9d4b0b6b3b253111abcf8ee0685a802cb337c0"
    sha256 cellar: :any,                 sonoma:         "2c5e5eb7b06f1a57b66ed8a4b5be35002a0bcdf97cc1d295636d1b1600681fd1"
    sha256 cellar: :any,                 ventura:        "94a9b42cf27c27998672ca56ca6601e2dc8e805b8a86f12650783ef7baafc92c"
    sha256 cellar: :any,                 monterey:       "48e837968fa146ce08c9ec0236b6968c3c9a28a769c028e77aff0744362c45fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c251fc30920d4e5ea23eede2d5e8c8df7ca58f237be2bdd85ee1bbb05f16197"
  end

  depends_on "pkg-config" => :test

  on_linux do
    depends_on "readline"
  end

  def install
    system "make", "prefix=#{prefix}", "release"
    system "make", "prefix=#{prefix}", "install"
    system "make", "prefix=#{prefix}", "install-shared" if build.stable?
  end

  test do
    (testpath/"test.js").write <<~EOS
      print('hello, world'.split().reduce(function (sum, char) {
        return sum + char.charCodeAt(0);
      }, 0));
    EOS
    assert_equal "104", shell_output("#{bin}/mujs test.js").chomp
    # test pkg-config setup correctly
    assert_match "-I#{include}", shell_output("pkg-config --cflags mujs")
    assert_match "-L#{lib}", shell_output("pkg-config --libs mujs")
    system "pkg-config", "--atleast-version=#{version}", "mujs"
  end
end
