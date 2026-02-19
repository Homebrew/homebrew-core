class FontUtil < Formula
  desc "X.Org: Font package creation/installation utilities"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/font/font-util-1.4.1.tar.xz"
  sha256 "5c9f64123c194b150fee89049991687386e6ff36ef2af7b80ba53efaf368cc95"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e81859b3665bc1d739ed7a6d7844fb00408b423a1a974dba3f4d53afcfdb15f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1e8982b1136f3b7dc2667de6eda27c7a8f90b6203907996c17e3afff344ca17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07818746685ef7ff1be5495b2864c494bcb1cecca807748f5d54ddd349bc363d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a762c78c7117532ef466b0f92cb9afe68067fdebecf6a702281f7daac8273be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aab35c752e837191fc9ae9aa898844651080a4ad9cf97e0b8047331671f04510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59a413b8a4634f05af50fa9f6be3ff29f872314bc644701ab17e5aaffe3d0361"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "util-macros" => :build

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-fontrootdir=#{HOMEBREW_PREFIX}/share/fonts/X11
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "fontrootdir=#{share}/fonts/X11", "install"

    dirs = %w[encodings 75dpi 100dpi misc]
    dirs.each do |d|
      (share/"fonts/X11/#{d}").mkpath
      touch share/"fonts/X11/#{d}/.keepme"
    end
  end

  test do
    system "pkgconf", "--exists", "fontutil"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
