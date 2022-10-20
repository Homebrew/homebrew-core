class Nutcracker < Formula
  desc "Proxy for memcached and redis"
  homepage "https://github.com/twitter/twemproxy"
  url "https://github.com/twitter/twemproxy/archive/0.5.0.tar.gz"
  sha256 "73f305d8525abbaaa6a5f203c1fba438f99319711bfcb2bb8b2f06f0d63d1633"
  license "Apache-2.0"
  revision 1
  head "https://github.com/twitter/twemproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c8c9e289383ed4b606246b5300a2b768642ed231a0526e6e9dab6e2f37e762bc"
    sha256 cellar: :any,                 arm64_big_sur:  "5063c8fb5c2f1327bb0979be76cf05be72b879113b69667d9d6548d1db6da44b"
    sha256 cellar: :any,                 monterey:       "0682fca355c4930be73a43fca315d8eb36a709413f60ebae19f58289eafe1916"
    sha256 cellar: :any,                 big_sur:        "a8a718227faa82141b08684c12654a04dee9ffc91df8157100fb5b51eb6fe8ba"
    sha256 cellar: :any,                 catalina:       "95055ec8487419f854e34be6212369081eaa574ebaa36dabb01b2047f2e31240"
    sha256 cellar: :any,                 mojave:         "eabbabd68f1627872a910374a15186b3c57c7ef7ebfa99a8d1a32bc15edf2f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d6d4dcbb634abf13629537e4eaa0ee3a9fe87693492c3668c4effe4550a2cd8"
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
