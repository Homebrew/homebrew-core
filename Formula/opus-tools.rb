class OpusTools < Formula
  desc "Utilities to encode, inspect, and decode .opus files"
  homepage "https://www.opus-codec.org"
  url "https://archive.mozilla.org/pub/opus/opus-tools-0.2.tar.gz", using: :homebrew_curl
  sha256 "b4e56cb00d3e509acfba9a9b627ffd8273b876b4e2408642259f6da28fa0ff86"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "9d41440b3bb51ecad281baffd64487094ab066f6224f69f3d1054cfe7fc4e4ab"
    sha256 cellar: :any,                 arm64_big_sur:  "33c1b089709532f82978e0f0fade8bbbf0c56ef07c81d7d22f8e8b649d0c72ca"
    sha256 cellar: :any,                 monterey:       "5a55452d95fa21800605af38fae3516f415b78042e975b65ebc152790db1d148"
    sha256 cellar: :any,                 big_sur:        "437d89ccde33e47708506a235fd68e2a3745d7848498dd1ce72e8c77a1e74dcc"
    sha256 cellar: :any,                 catalina:       "964b3493cffeb5e32411c7a34e1813e8e83e940419aca39f50be7db9b0c8fab2"
    sha256 cellar: :any,                 mojave:         "c4059aca471c3b1ec384323c1c801b844a2d2b61f17434ebc43c0accffde9f9b"
    sha256 cellar: :any,                 high_sierra:    "0f8828cf6044f2d7b0cac9c591295b420244e8f086dc0afae9ae5420e6be7cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "163de268a10eb01b4de4047ce4f0df9c180077418b7fbecf79efe9e5f193ca81"
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
