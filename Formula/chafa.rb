class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.12.3.tar.xz"
  sha256 "2456a0b6c1150e25b64cd6a92810d59bed3f061f8b86f91aba5a77bc7cc76cfa"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5ded225501393aeb4d440ee5b6828f9f36652b2d13611ab6309e0f57cec39f98"
    sha256 cellar: :any,                 arm64_big_sur:  "01f0de70f1bb8c1cecec0438a8c48e9c7bb0f586a4b4fc1f7e788f133748798c"
    sha256 cellar: :any,                 monterey:       "607d4389c2a2de399626ca9fbdd1437f623e3805f5274181e1833c128989465b"
    sha256 cellar: :any,                 big_sur:        "8efd1078b28af72bc5288df4b2d24ba298ec1d1f3331e8aff3df1f0ddf37f3b4"
    sha256 cellar: :any,                 catalina:       "c24318e241aca264fdf2a6ded042a2563c5336e59b35dd7b64339a8d72eb2946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa8bf974fe28dda61b53a2e332074121bfeae419e5ceb34dfd02c67d95355a8a"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "imagemagick"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # imagemagick is built with GCC

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
    man1.install "docs/chafa.1"
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 2, output.lines.count
  end
end
