class FontUtil < Formula
  desc "X.Org: Font package creation/installation utilities"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/font/font-util-1.3.3.tar.xz"
  sha256 "e791c890779c40056ab63aaed5e031bb6e2890a98418ca09c534e6261a2eebd2"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e2205892be19c7afd594a119f156c34be0bbb2ff558e27f607a1abfd4aa39e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0493ee9b21dd723d64b310c0e1155b78d580c3f51b9aedfc03f064fdfa8b4231"
    sha256 cellar: :any_skip_relocation, monterey:       "4abf110cc5d3f23041b1b13f743f86984dd764a53f1b769d98c2330cdbe01e41"
    sha256 cellar: :any_skip_relocation, big_sur:        "735dff962371dc31717a0401bebbf06fd3b243f7387525ceb18be858e87fc3b7"
    sha256 cellar: :any_skip_relocation, catalina:       "37dc2a615d64130304086369728deece1b35ed5ad28a7053d0ff6ebfd01256d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af731bff16e8e79be7bef74b083bf19c1310d194801feca4fd92dc9d0925be0b"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "util-macros" => :build

  def install
    args = std_configure_args + %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-fontrootdir=#{HOMEBREW_PREFIX}/share/fonts/X11
    ]

    system "./configure", *args
    system "make"
    system "make", "fontrootdir=#{share}/fonts/X11", "install"
  end

  def post_install
    dirs = %w[encodings 75dpi 100dpi misc]
    dirs.each do |d|
      mkdir_p share/"fonts/X11/#{d}"
    end
  end

  test do
    system "pkg-config", "--exists", "fontutil"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
