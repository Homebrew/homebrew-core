class FontsEncodings < Formula
  desc "Font encoding tables for libfontenc"
  homepage "https://gitlab.freedesktop.org/xorg/font/encodings"
  url "https://www.x.org/archive/individual/font/encodings-1.1.0.tar.xz"
  sha256 "9ff13c621756cfa12e95f32ba48a5b23839e8f577d0048beda66c67dab4de975"
  license :public_domain

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a39912b6117c4a81737d5e1f98b0ec5593a361776de0ec00db20403d38a76990"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d9eda2b888cf0341ae65cca2b90c91e86967c8afdb6d9c2bd43424fc2a26fe12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59c87e4e30083b75e3018ad22f97910fad4e0a836078f4004dd317e5fe15a0bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59c87e4e30083b75e3018ad22f97910fad4e0a836078f4004dd317e5fe15a0bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59c87e4e30083b75e3018ad22f97910fad4e0a836078f4004dd317e5fe15a0bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "59c87e4e30083b75e3018ad22f97910fad4e0a836078f4004dd317e5fe15a0bd"
    sha256 cellar: :any_skip_relocation, ventura:        "59c87e4e30083b75e3018ad22f97910fad4e0a836078f4004dd317e5fe15a0bd"
    sha256 cellar: :any_skip_relocation, monterey:       "59c87e4e30083b75e3018ad22f97910fad4e0a836078f4004dd317e5fe15a0bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1f857df9e20b609e0039a4ca026aeb47950281cefefbe63f9fe051fcf79529ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1db746be5c88ea8ceebfc07dd720c2f004b4e82e1c86fb311314ad0698ff8a20"
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
    assert_path_exists share/"fonts/X11/encodings/encodings.dir"
  end
end
