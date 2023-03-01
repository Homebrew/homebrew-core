class FontsEncodings < Formula
  desc "Font encoding tables for libfontenc"
  homepage "https://gitlab.freedesktop.org/xorg/font/encodings"
  url "https://www.x.org/archive/individual/font/encodings-1.0.7.tar.xz"
  sha256 "3a39a9f43b16521cdbd9f810090952af4f109b44fa7a865cd555f8febcea70a4"
  license :public_domain

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "863542f9892912c4f98cf5f8af13dbb2bc2be16d674559759e8d2b003d12ce56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "863542f9892912c4f98cf5f8af13dbb2bc2be16d674559759e8d2b003d12ce56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "863542f9892912c4f98cf5f8af13dbb2bc2be16d674559759e8d2b003d12ce56"
    sha256 cellar: :any_skip_relocation, ventura:        "863542f9892912c4f98cf5f8af13dbb2bc2be16d674559759e8d2b003d12ce56"
    sha256 cellar: :any_skip_relocation, monterey:       "863542f9892912c4f98cf5f8af13dbb2bc2be16d674559759e8d2b003d12ce56"
    sha256 cellar: :any_skip_relocation, big_sur:        "863542f9892912c4f98cf5f8af13dbb2bc2be16d674559759e8d2b003d12ce56"
    sha256 cellar: :any_skip_relocation, catalina:       "863542f9892912c4f98cf5f8af13dbb2bc2be16d674559759e8d2b003d12ce56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccc20d215d88365698fdd40a5066d867e2d465e5057a0084ded551a433ab088f"
  end

  depends_on "font-util"   => :build
  depends_on "mkfontscale" => :build
  depends_on "util-macros" => :build

  def install
    configure_args = std_configure_args + %W[
      --with-fontrootdir=#{share}/fonts/X11
    ]

    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_predicate share/"fonts/X11/encodings/encodings.dir", :exist?
  end
end
