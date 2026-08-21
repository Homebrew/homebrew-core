class Felinks < Formula
  desc "Text mode browser and Gemini, NNTP, FTP, Gopher, Finger, and BitTorrent client"
  homepage "https://github.com/rkd77/elinks"
  url "https://github.com/rkd77/elinks/releases/download/v0.20.0/elinks-0.20.0.tar.xz"
  sha256 "75af7ba88af99ff5069ec7b4b7a3241d5920f4089764c7297cff3c8484a9e33f"
  license "GPL-2.0-only"
  head "https://github.com/rkd77/elinks.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "804d1b3d616ab0e9c86b93255d083edc11fa1d2712f4b8af895c6bd755a03a5d"
    sha256 cellar: :any, arm64_sequoia: "f99ce5754dc6c1ca5da7b8d9e2cb8458d2b204ce111fbd83f31f08ca0c95a37d"
    sha256 cellar: :any, arm64_sonoma:  "5f5afff26bebf42b4a252e65412f9f18bcfc308cdc3a8283b4e895f32a07984e"
    sha256 cellar: :any, sonoma:        "e38c3fd569881af542f8f84f1d29896b4d370d8cef402a2d0a8368dc0049a44c"
    sha256               arm64_linux:   "4e932d76b25f7c7bef491cd7a3211b19cbe2fcb3cf773256b96ccad103393760"
    sha256               x86_64_linux:  "351d479c1388e91660ce963d57d03dfc4832647f71278e0ae4f459475ce534d3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "brotli"
  depends_on "gnutls" # not using OpenSSL due to license compatibility
  depends_on "libcss"
  depends_on "libdom"
  depends_on "libgcrypt"
  depends_on "libidn2"
  depends_on "libwapcaplet"
  depends_on "tre"

  uses_from_macos "bison" => :build
  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # We use GnuTLS rather than OpenSSL as Apache-2.0 is not compatible with GPL-2.0-only
    # Ref: https://www.gnu.org/licenses/license-list.html#apache2
    # Ref: https://github.com/rkd77/elinks/blob/master/INSTALL#L95-L110
    args = %w[
      -D256-colors=true
      -D88-colors=true
      -Dbittorrent=true
      -Dbrotli=true
      -Dcgi=true
      -Dexmode=true
      -Dfinger=true
      -Dgemini=true
      -Dgnutls=true
      -Dgopher=true
      -Dgpm=false
      -Dhtml-highlight=true
      -Dnls=false
      -Dnntp=true
      -Dopenssl=false
      -Dperl=false
      -Dspidermonkey=false
      -Dtre=true
      -Dtrue-color=true
      -Dx=false
      -Dxterm=false
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.html").write <<~HTML
      <!DOCTYPE html>
      <title>Hello World!</title>
      Abracadabra
    HTML
    assert_match "Abracadabra", shell_output("#{bin}/elinks -dump test.html").chomp
  end
end
