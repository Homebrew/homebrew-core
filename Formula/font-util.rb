class FontUtil < Formula
  desc "X.Org: Font package creation/installation utilities"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/font/font-util-1.3.3.tar.xz"
  sha256 "e791c890779c40056ab63aaed5e031bb6e2890a98418ca09c534e6261a2eebd2"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e12c0d135ebb8f71ca2a975689b82f89779b4a2b2147c38e6a9a5fbcd489864e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57edda9390b2123b1f9b31651b5ad03e8888ccd7a1f5409d7795c18f9fa6a31d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c668bc56ced30ffb6ac8838ed40fd219538b2155cd810d5978ac5ce4b34d6992"
    sha256 cellar: :any_skip_relocation, ventura:        "db0993a605544bcffd74440bbc1c322768afa11fc6fcb9abe82c2141b34bb1f7"
    sha256 cellar: :any_skip_relocation, monterey:       "cd192a5dfbc1dc6667caacc87445fb028905141d059c33c61124f544a17f6838"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b7d236e3d49b24292959ccfd78bf2479887eef9d7c0a7ac670008c9f410af5b"
    sha256 cellar: :any_skip_relocation, catalina:       "198d4383e2e254f2c81f0227e416635a8435ea4cf2fd6a8ce814315ecadd2a80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1225cda3cc0e81f7a85285b12ebba475b219041749de9b0e8a31af87ef651f46"
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
