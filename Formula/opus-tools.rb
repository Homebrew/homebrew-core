class OpusTools < Formula
  desc "Utilities to encode, inspect, and decode .opus files"
  homepage "https://www.opus-codec.org"
  url "https://archive.mozilla.org/pub/opus/opus-tools-0.2.tar.gz", using: :homebrew_curl
  sha256 "b4e56cb00d3e509acfba9a9b627ffd8273b876b4e2408642259f6da28fa0ff86"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e669aabf26e7442abf72f6da53fe076651f3f9ff78ccbce431e40aedc3d759b1"
    sha256 cellar: :any,                 arm64_monterey: "35645fc571599ef38123e90bb45de43ac7b7d088ba2c755dccc498655d7b2820"
    sha256 cellar: :any,                 arm64_big_sur:  "9e795afea16e37e7ad109653a68b4eb4a3c267bf19ee0d9c691854b398aaa79f"
    sha256 cellar: :any,                 ventura:        "aa6fb58f6cf3c27a8197dae41b801b1385b4eb5738027a4c7879070185705407"
    sha256 cellar: :any,                 monterey:       "c50e81f56f1498244a3293d1cb3373c3a53b296b82e8be0d2c1ae09d0b398012"
    sha256 cellar: :any,                 big_sur:        "5129aef8463b74eebc1e8f0535a6eaf7013b0e29a270c4cbbd2a9cb452afdef6"
    sha256 cellar: :any,                 catalina:       "9fc7ca7376b88a6c0fbbb0418b0442913783203d8b0aac4c6ea8e95c09c1f7f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ccd10e6c8436925ccbaa9dda69314fc2f5c243c6a3205dfe62885216de67bd7"
  end

  head do
    url "https://gitlab.xiph.org/xiph/opus-tools.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libogg"
  depends_on "libopusenc"
  depends_on "opus"
  depends_on "opusfile"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    cp test_fixtures("test.wav"), "test.wav"
    assert_match "Encoding complete", shell_output("#{bin}/opusenc test.wav enc.opus 2>&1")
    assert_predicate testpath/"enc.opus", :exist?, "Failed to encode to enc.opus"
    assert_match "Decoding complete", shell_output("#{bin}/opusdec enc.opus dec.wav 2>&1")
    assert_predicate testpath/"dec.wav", :exist?, "Failed to decode to dec.wav"
  end
end
