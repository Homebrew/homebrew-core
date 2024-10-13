class Cracklib < Formula
  desc "LibCrack password checking library"
  homepage "https://github.com/cracklib/cracklib"
  url "https://github.com/cracklib/cracklib/releases/download/v2.10.2/cracklib-2.10.2.tar.bz2"
  sha256 "e157c78e6f26a97d05e04b6fe9ced468e91fa015cc2b2b7584889d667a958887"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia:  "f6e2026b98603f1a97a29c292ef672921cac28cdba20704902d719a7348dd02f"
    sha256 arm64_sonoma:   "0c5f49a46e9db39c735041120c5e89b06b1ec2b0e37ba2090973f2067ebee3ef"
    sha256 arm64_ventura:  "c03e267a7d0d790f718537b89fa25c6aac1f7f75a3f23addfd07e059305d97b1"
    sha256 arm64_monterey: "e76849125f0b2ee7631f381249e9b0acae465b5128c0d255a76fc0112a78539b"
    sha256 sonoma:         "9da52404b23c1520018c0c412aefc7464d7cb0a088be20fc8105dd0df3577eb4"
    sha256 ventura:        "65bf3c3f8b218c977b4bec89d25b27e21f5ffed8329510ba8227b7b0208375b6"
    sha256 monterey:       "cd6d93ae08c1d7c2459f8bc95f3274f2d34c862ea5c1eceeb025ca74fce180a7"
    sha256 x86_64_linux:   "9ecde5232f61599c25890b9056d7abfb6a15e30569eda7fb96eb5e447fe651d7"
  end

  head do
    url "https://github.com/cracklib/cracklib.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  resource "cracklib-words" do
    url "https://github.com/cracklib/cracklib/releases/download/v2.10.2/cracklib-words-2.10.2.bz2"
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
