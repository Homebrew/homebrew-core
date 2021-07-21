class Nutcracker < Formula
  desc "Proxy for memcached and redis"
  homepage "https://github.com/twitter/twemproxy"
  url "https://github.com/twitter/twemproxy/archive/0.5.0.tar.gz"
  sha256 "73f305d8525abbaaa6a5f203c1fba438f99319711bfcb2bb8b2f06f0d63d1633"
  license "Apache-2.0"
  revision 1
  head "https://github.com/twitter/twemproxy.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "1de200c6883d487250e2bcd80c0eaa0b7b661be7e60f4f5afd7b300e5a093d8c"
    sha256 cellar: :any,                 big_sur:       "ea277cd62fb6eacc902dbffafa0d05ac3b7ef30c118bbaa164c5112c2dc4838e"
    sha256 cellar: :any,                 catalina:      "a0f29dfef521df43e6fe73cda13cadf95aab2ccd88a006d29eb91272fcb87deb"
    sha256 cellar: :any,                 mojave:        "e725be8c70ed22541146d804adb0fc0cc748a0152effd2565bdbc7a45655aeff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfc6c7d6529e63fc4b1d2843d8b0d928ab2cd7aa11dbcfe3b449e81b2af92f51"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libyaml"

  # Use Homebrew libyaml instead of the vendored one.
  # Adapted from Debian's equivalent patch.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0e1ac7ef20e83159554b6522380b1c4b48ce4f2f/nutcracker/use-system-libyaml.patch"
    sha256 "9105f2bd784f291da5c3f3fb4f6876e62ab7a6f78256f81f5574d593924e424c"
  end

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    pkgshare.install "conf", "notes", "scripts"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/nutcracker -V 2>&1")
  end
end
