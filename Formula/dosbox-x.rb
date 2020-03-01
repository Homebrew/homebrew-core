class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.82.26.tar.gz"
  sha256 "46f6ae899253bd3cfd707b6a549f971d9b1f6f67062513132f1d89676051e7e1"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    sha256 "c392c5aea8e6771d32dc72d22d28da796cced4e27ed64e51efa3bf34383aed02" => :catalina
    sha256 "8542963922f9f6b513f3588c1ee203371b2061d96966fd501aee565e7e5b1fc3" => :mojave
    sha256 "2c56e1ec558c7737569d46efb5b46fd2dea30077c6bfa5ca2b65ff511516b0e9" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "fluid-synth"
  depends_on :macos => :high_sierra # needs futimens

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
    ]
    system "./build-macosx", *args
    system "make", "install"
  end

  test do
    assert_match /DOSBox version #{version}/, shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
