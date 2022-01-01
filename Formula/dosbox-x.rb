class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.21.tar.gz"
  sha256 "ec13bf16a9761c755df25f8b780aee589e328bcd490ac372538f8a87846456a2"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git", branch: "master"

  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "f8151e55a8e0189680746b1465b7a88b07a0b25e7cf7a0aedf0385702c6e2692"
    sha256 cellar: :any, arm64_big_sur:  "de2cd9165ca930d79f407005c778a54ac8a879661cb6828c3b6ac6b65735458b"
    sha256 cellar: :any, monterey:       "e3e12f937bf5495b440d761964deb3feadd5e7d823647582e477f9372b6ee87a"
    sha256 cellar: :any, big_sur:        "7c031b5ed275bf3c6eba75e4d42ed5007878cba684cdd7405d0d1599797d79cc"
    sha256 cellar: :any, catalina:       "7b2166e2420e5f709824221db141bfaaf946fb8dba21f721351ec0605ef4a482"
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
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
