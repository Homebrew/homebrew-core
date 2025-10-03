class OpusTools < Formula
  desc "Utilities to encode, inspect, and decode .opus files"
  homepage "https://www.opus-codec.org/"
  url "https://ftp.osuosl.org/pub/xiph/releases/opus/opus-tools-0.2.tar.gz"
  mirror "https://archive.mozilla.org/pub/opus/opus-tools-0.2.tar.gz"
  sha256 "b4e56cb00d3e509acfba9a9b627ffd8273b876b4e2408642259f6da28fa0ff86"
  license "BSD-2-Clause"
  revision 2

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/opus/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)opus-tools[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec7af6774ddcc95aca50060460f3fd6fd3dcc97b78ee2c64e9230b2d7e0e958f"
    sha256 cellar: :any,                 arm64_sequoia: "2e17161e605515377130ebeb2edecf02a4518a8c27373e3eca594cfd48ed6de5"
    sha256 cellar: :any,                 arm64_sonoma:  "1ccc81bd48aa589c8743efb2e88493da699be27e78a7c213616ddbde5caa24b2"
    sha256 cellar: :any,                 arm64_ventura: "7f67fcf51d7b7b4e72db4e7445e4d5a6465051fe2a3d1d6655375a783d5c1372"
    sha256 cellar: :any,                 sonoma:        "be32020f65c0ac4614a81c6aee8adb3d5a2918625c7e33bafa80c7162d561784"
    sha256 cellar: :any,                 ventura:       "3916eb7536e8928698b77b9c7b40fa103e1f05848b3babca581f7f50709b9536"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceba1cc3046ad55c60b3883c3d9cd1272c9f308c2bb9edb011d7ec070a6feebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dde385e2c30d9478123ea358ab5b4786c7337cbb2728202eab4806926f02bf7d"
  end

  head do
    url "https://gitlab.xiph.org/xiph/opus-tools.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
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
    assert_path_exists testpath/"enc.opus", "Failed to encode to enc.opus"
    assert_match "Decoding complete", shell_output("#{bin}/opusdec enc.opus dec.wav 2>&1")
    assert_path_exists testpath/"dec.wav", "Failed to decode to dec.wav"
  end
end
