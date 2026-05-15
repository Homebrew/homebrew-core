class FontUtil < Formula
  desc "X.Org: Font package creation/installation utilities"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/font/font-util-1.4.2.tar.xz"
  sha256 "02e4f8afdcf03cc8372ca9c37aa104b1e36b47722dbc79531be08f0a4c622999"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c36ca76580fb353bdfe1380fd2f21bda85acccd1a877a231af3053752e4c48c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e57594b7b9b844d9ca329f6a0a5e579ea4d7ca1f62cd3815d98a3fe19ff2f6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c409f69f033ad5a336b146d8af4a884c941dc6f02840dfd2f38b63e0b3476bf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ff16d09fbc8f9efdf1ffb3c3cb6dcb1f01c3e39042c75d572a8f7ae3f84b21f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6dcbba120003015b76776467dc9354131b9889e8feb84be4f24fddb181aa1ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9586086bb39cbbd36fa3e2846e7ac568e435e50e43ac1adda639642ad509e05"
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
