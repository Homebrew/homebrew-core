class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.0.tar.gz"
  sha256 "cc5beafa32bde866b5f54b46229feb743abee7dbd84becc9735709efb8189283"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    sha256 "50c4f1eef202f3911273db2e03c29dc5181e2c5202791d82c4ce24e0d8b90e00" => :catalina
    sha256 "dda9ef26dac2c2dc2d5f4b1eef727ffedde93d7b4aaac31fed48c022c4601e5e" => :mojave
    sha256 "c343baffac58d607f92ea068316f134a82d3849b50b475c6a9fd59caad5eb1c0" => :high_sierra
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
