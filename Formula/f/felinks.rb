class Felinks < Formula
  desc "Text mode browser and Gemini, NNTP, FTP, Gopher, Finger, and BitTorrent client"
  homepage "https://github.com/rkd77/elinks"
  url "https://github.com/rkd77/elinks/releases/download/v0.19.1/elinks-0.19.1.tar.xz"
  sha256 "31960cd471246692b84008bffec89182f25818472f86ee1a41a09bf0dad09eeb"
  license "GPL-2.0-only"
  head "https://github.com/rkd77/elinks.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "35dfb43eb4b1725d8a24ac65a645f12cb29cbdc01b4867d2635a582da2a89403"
    sha256 cellar: :any, arm64_sequoia: "b748604229c17f0489bae13279b299e25f4d541964a98f029f0eeba7bbe9fd56"
    sha256 cellar: :any, arm64_sonoma:  "dab153f838fd7ed4759785df2af819abbcf4daaf665ce5efa399f861d611acce"
    sha256 cellar: :any, sonoma:        "1d44dd8e0bca282c03bc38097e2ec1d679e72953ba38788f2336301de69a001d"
    sha256               arm64_linux:   "dcb42b5456167588d0749e5bd36ca3c68112ffa5bd64e7d5656e623684ffc1bc"
    sha256               x86_64_linux:  "4388f0c783c699960df5bdadc747c68183249ec9bcb564fc1b6875474c39fee7"
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
