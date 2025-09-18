class Pdf2svg < Formula
  desc "PDF converter to SVG"
  homepage "https://cityinthesky.co.uk/opensource/pdf2svg"
  url "https://github.com/dawbarton/pdf2svg/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "fd765256f18b5890639e93cabdf631b640966ed1ea9ebd561aede9d3be2155e4"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "58b344d12758452174b82e00489ee46159fd8522d1665748c87226b390bb2a42"
    sha256 cellar: :any,                 arm64_sequoia: "9d3dee3bc068da7b48766e2020f59c88b699526c1e0649569ff6ead73832a2d2"
    sha256 cellar: :any,                 arm64_sonoma:  "f9b0270d4da35600e7747b489f2e7e4189b61781e62ba1bf288516e4006b04e4"
    sha256 cellar: :any,                 arm64_ventura: "e5fde5427d8f50595f2ef126a344279f95b24aed9097db080b25b3afa0999f6d"
    sha256 cellar: :any,                 sonoma:        "0f825f54919369deb5adc309ff369f6679c53b04d89a240fec3d031f004d63ef"
    sha256 cellar: :any,                 ventura:       "fba60b0a305fdb79d8034016b76a2eecd88ca173e0321115ee395c03194e4852"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6b1ca19d159da250501acac0611393208b5bd33b797014c02825eea3c7ebba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbb6cfd9a930910cb3c8d58c1ee940b6ba0df882292f6252a7c03ce23e0bacf0"
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "poppler"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    system bin/"pdf2svg", test_fixtures("test.pdf"), "test.svg"
  end
end
