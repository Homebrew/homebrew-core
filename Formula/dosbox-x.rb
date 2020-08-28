class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.4.tar.gz"
  sha256 "0fcd9bf17c0bdb2fc5264b1e92a6731758988179e38c727f0fc64002efe19165"
  license "GPL-2.0"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  livecheck do
    url :head
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "1c82f41f94e7edd7436dacdf757711c6610b422601c8ce5a0678e73238cfdea2" => :catalina
    sha256 "b8c0bd8009939855547f7052f8bc1db1e830075aa73a10956459d2891610efdf" => :mojave
    sha256 "2b9e3c467fa195763a0eefc686a9941b6939a143924945c13684a92dd347f607" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on macos: :high_sierra # needs futimens

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
    assert_match /DOSBox-X version #{version}/, shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
