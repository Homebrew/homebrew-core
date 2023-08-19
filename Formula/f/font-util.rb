class FontUtil < Formula
  desc "X.Org: Font package creation/installation utilities"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/font/font-util-1.4.0.tar.xz"
  sha256 "9f724bf940128c7e39f7252bd961cd38cfac2359de2100a8bed696bf40d40f7d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c8d5bd77984bd50d7899209f12e78c7e693791fb22149662cbc7bfde3e519fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10fbd2af6d4cdb24e97614e040e60de26f174f36fad7830f4b1d84dc2de60bc1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68ef54c83f61897323c56c807743f4f762e24a8222ce2f6b5dba95e3646d2b1d"
    sha256 cellar: :any_skip_relocation, ventura:        "5aeaa5fbf6dbd337b42ccaa2824cf0b84862ba9c716d000c58eaa11af1d94cff"
    sha256 cellar: :any_skip_relocation, monterey:       "e9aa45b03776dfac3b55b793fc8f44252cc022bec1edac356628f7142e0c5318"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ce16c7d22c356795f84c104b9d73eddab5620660d8d321a06d845ae951b981a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c3e9cf334af8c2d58014b67b6bee26d09ad35e56b514fa7a8275cc1383211e0"
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
