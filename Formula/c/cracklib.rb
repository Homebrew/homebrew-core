class Cracklib < Formula
  desc "LibCrack password checking library"
  homepage "https://github.com/cracklib/cracklib"
  url "https://github.com/cracklib/cracklib/releases/download/v2.10.3/cracklib-2.10.3.tar.bz2"
  sha256 "f3dcb54725d5604523f54a137b378c0427c1a0be3e91cfb8650281a485d10dae"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "bfe6f4fcc9715b80c772bc82847977a8514960010c677c3f497cef0ffe571338"
    sha256 arm64_sequoia: "05e23a17250844d8ce26720dbda596db1c5957b0886e44648ba957c85af67a21"
    sha256 arm64_sonoma:  "4160ab423c5ae473533dccee9580626706f964231cfb8f1693ebaae91ce23a7b"
    sha256 sonoma:        "35c49fa815da588e05b06289ef462503741f92ade3897d01fcf1f5cb1726d14c"
    sha256 arm64_linux:   "707b67a337adda7425720a25ba33911c531845c3db75097e48151e6189117685"
    sha256 x86_64_linux:  "92844634f5c499f9b31242fa1f05dd4657ac68fb2d335e3cbe5bd6002970e2c2"
  end

  head do
    url "https://github.com/cracklib/cracklib.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "cracklib-words" do
    url "https://github.com/cracklib/cracklib/releases/download/v2.10.3/cracklib-words-2.10.3.bz2"
    sha256 "ec25ac4a474588c58d901715512d8902b276542b27b8dd197e9c2ad373739ec4"
  end

  def install
    buildpath.install (buildpath/"src").children if build.head?
    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    system "./configure", "--disable-silent-rules",
                          "--sbindir=#{bin}",
                          "--without-python",
                          "--with-default-dict=#{var}/cracklib/cracklib-words",
                          *std_configure_args
    system "make", "install"

    share.install resource("cracklib-words")
  end

  def post_install
    (var/"cracklib").mkpath
    cp share/"cracklib-words-#{resource("cracklib-words").version}", var/"cracklib/cracklib-words"
    system "#{bin}/cracklib-packer < #{var}/cracklib/cracklib-words"
  end

  test do
    assert_match "password: it is based on a dictionary word", pipe_output(bin/"cracklib-check", "password", 0)
  end
end
