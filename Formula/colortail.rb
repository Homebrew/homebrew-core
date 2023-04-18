class Colortail < Formula
  desc "Like tail(1), but with various colors for specified output"
  homepage "https://github.com/joakim666/colortail"
  url "https://github.com/joakim666/colortail.git",
      revision: "f44fce0dbfd6bd38cba03400db26a99b489505b5"
  version "0.3.4"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01d31038e80f6c276198a8dba844c6090156125163588cb42b344673507c68e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "620058633e6ec31c36c0cc251d355a1ec4537f91d1563e95b5308561b2277fdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d7e35ff95a2d161fc60fcefa368c901dbe3ff1c973025f7f4c96617fd959fc3"
    sha256 cellar: :any_skip_relocation, ventura:        "83d2bb33d8908c63fa2c1c7112afe87c90fd1b185b0783b0fd05e6f0cf910a48"
    sha256 cellar: :any_skip_relocation, monterey:       "94feb2affa50d2d9e6b829d1608246f4a4aa15b09adc485080da655022a822ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cbd1fd25ee747f5c8db91de50511cc93ded9deb1b6daf99b343f5efaf449cda"
    sha256 cellar: :any_skip_relocation, catalina:       "76e327c10e6614aed10396f4da1008eda7d0574c77b009e6c4cc109829033bb1"
    sha256 cellar: :any_skip_relocation, mojave:         "f68bafd58bcff89453bf8f81331eb968c5bde460821a885523863ec4ee9482fb"
    sha256 cellar: :any_skip_relocation, high_sierra:    "a7974ddb2f0bd3a7946bb5d06fe637f94c7a8776f9cd811bf8fbd530caa92816"
    sha256 cellar: :any_skip_relocation, sierra:         "44e09610d285f503fbae67f930ae7bea894c737d1e2c9c634332188340a70e3e"
    sha256 cellar: :any_skip_relocation, el_capitan:     "e0c8c9af739ce911c0d09eaee26b615444c17f48de27c680cbaf27739e45d8f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bb6017dc4e925d2ac5de5eedf2202e6a45a1f59b941faa6518e3038acca544c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  # Upstream PR to fix the build on ML
  patch do
    url "https://github.com/joakim666/colortail/commit/36dd0437bb364fd1493934bdb618cc102a29d0a5.patch?full_index=1"
    sha256 "d799ddadeb652321f2bc443a885ad549fa0fe6e6cfc5d0104da5156305859dd3"
  end

  def install
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Hello\nWorld!\n"
    assert_match(/World!/, shell_output("#{bin}/colortail -n 1 test.txt"))
  end
end
