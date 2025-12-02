class Nutcracker < Formula
  desc "Proxy for memcached and redis"
  homepage "https://github.com/twitter/twemproxy"
  url "https://github.com/twitter/twemproxy/archive/refs/tags/0.5.0.tar.gz"
  sha256 "73f305d8525abbaaa6a5f203c1fba438f99319711bfcb2bb8b2f06f0d63d1633"
  license "Apache-2.0"
  revision 1
  head "https://github.com/twitter/twemproxy.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "abf045b842b325b9beae4b4081057f70d458359c2fae9b4792a4130d74120943"
    sha256 cellar: :any,                 arm64_sequoia:  "9858288de204b1ebddc2500149b07ad6cc6c08f92f37936d0055b5f4820bbb03"
    sha256 cellar: :any,                 arm64_sonoma:   "878651e4b64cf8af3146bee562a15dcd18bb880a65ede75b61c7232c982db60e"
    sha256 cellar: :any,                 arm64_ventura:  "72e440a578846be30b99237a05ac9251ad0859aa19fb4603e73671c61add0e66"
    sha256 cellar: :any,                 arm64_monterey: "c8c9e289383ed4b606246b5300a2b768642ed231a0526e6e9dab6e2f37e762bc"
    sha256 cellar: :any,                 arm64_big_sur:  "5063c8fb5c2f1327bb0979be76cf05be72b879113b69667d9d6548d1db6da44b"
    sha256 cellar: :any,                 sonoma:         "bc0b16855feadbbf05d9eeb0373c73ed1ec2ad6ee2f98686e328f71f65510c60"
    sha256 cellar: :any,                 ventura:        "0fa603b54d16e0a34fc38095337cb3809ec3180249a18b114708aec49c344871"
    sha256 cellar: :any,                 monterey:       "0682fca355c4930be73a43fca315d8eb36a709413f60ebae19f58289eafe1916"
    sha256 cellar: :any,                 big_sur:        "a8a718227faa82141b08684c12654a04dee9ffc91df8157100fb5b51eb6fe8ba"
    sha256 cellar: :any,                 catalina:       "95055ec8487419f854e34be6212369081eaa574ebaa36dabb01b2047f2e31240"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9ac5ec0b8889f2bb83510eaacb9eb54b0247b236690469fb4511670d1aa73cd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d6d4dcbb634abf13629537e4eaa0ee3a9fe87693492c3668c4effe4550a2cd8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libyaml"

  # Use Homebrew libyaml instead of the vendored one.
  # Adapted from Debian's equivalent patch.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/nutcracker/use-system-libyaml.patch"
    sha256 "9105f2bd784f291da5c3f3fb4f6876e62ab7a6f78256f81f5574d593924e424c"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"

    pkgshare.install "conf", "notes", "scripts"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/nutcracker -V 2>&1")
  end
end
