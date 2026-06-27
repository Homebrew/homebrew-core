class Jbig2dec < Formula
  desc "JBIG2 decoder and library (for monochrome documents)"
  homepage "https://github.com/ArtifexSoftware/jbig2dec"
  url "https://github.com/ArtifexSoftware/jbig2dec/archive/refs/tags/0.20.tar.gz"
  sha256 "a9705369a6633aba532693450ec802c562397e1b824662de809ede92f67aff21"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "08de3bbe75ccd99324756e5687677f3855f31ec9057f16ce068de9301072dfd0"
    sha256 cellar: :any,                 arm64_sequoia:  "f581562914f78e334b62715f38a94884e133a0f5fd9f865bd51a6404250a650b"
    sha256 cellar: :any,                 arm64_sonoma:   "30f0053c48d777cdbf482bcffeb449fe173e3471e344c97bc129b8fe2f883629"
    sha256 cellar: :any,                 arm64_ventura:  "973a40cc673a331249be09ddef83537889f45f8934925c36e9b17e73cb852c40"
    sha256 cellar: :any,                 arm64_monterey: "7e52f5520ff0970c61fea2293db287b162b4de29c69f5032ae17a2cdab8fed22"
    sha256 cellar: :any,                 arm64_big_sur:  "8830470637ded079e4de807b63d8970b2e1020451b781f42a5dc0a6da7742479"
    sha256 cellar: :any,                 sonoma:         "8017bcda4a2d530aad05946e2196907a8fd52992aa3043001764adea0e2cf58b"
    sha256 cellar: :any,                 ventura:        "daab35fae8429496d00b301717837f656c4e166a3f384d8ccc0a2e1ae69f6c30"
    sha256 cellar: :any,                 monterey:       "907cf171d3bf5816be1036330bd09b93df351fde2ea414f99c388668e2637222"
    sha256 cellar: :any,                 big_sur:        "e2a6dc6113dda3fb85111dcc72c6f89fbac0800260cf4110956b3c984f74530e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "43fda0fa722603abe04fe456472b593fcbcfb933ebab2bedea48e2cc77e5cbfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb3732eb4744293f9354ab856ea2f9b350897fa5408ae9c07330ba454f3ec95c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  resource("test") do
    url "https://github.com/apache/tika/raw/master/tika-parsers/src/test/resources/test-documents/testJBIG2.jb2"
    sha256 "40764aed6c185f1f82123f9e09de8e4d61120e35d2b5c6ede082123749c22d91"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-silent-rules
      --without-libpng
    ]

    system "./autogen.sh", *args
    system "make", "install"
  end

  test do
    resource("test").stage testpath
    output = shell_output("#{bin}/jbig2dec -t pbm --hash testJBIG2.jb2")
    assert_match "aa35470724c946c7e953ddd49ff5aab9f8289aaf", output
    assert_path_exists testpath/"testJBIG2.pbm"
  end
end
