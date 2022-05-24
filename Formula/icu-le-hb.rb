class IcuLeHb < Formula
  desc "Implement the ICU Layout Engine (icu-le) using HarfBuzz"
  homepage "https://github.com/harfbuzz/icu-le-hb/"
  url "https://github.com/harfbuzz/icu-le-hb/releases/download/1.2.3/icu-le-hb-1.2.3.tar.gz"
  sha256 "d705d359a56e1a78c36becaba8a3e8cd338d3d0fdc0c6c2943cc836a7a04f247"
  license "ICU"
  head "https://github.com/harfbuzz/icu-le-hb.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "harfbuzz"
  depends_on "icu4c"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "true"
  end
end
