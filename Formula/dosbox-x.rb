class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.2.tar.gz"
  sha256 "87cfdf515b6c5a71afb3f5b1960d5cd323a0cce5643094713db3cf2ccb82b4bc"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    sha256 "293d6d8e1f0538280ecc63496f8d0c8c9339173813f2835e9a73651f95ad5100" => :catalina
    sha256 "6f764b3578c1d536c4a3694addc7e8b620538d48bb9c5043989b2a19b7453ba9" => :mojave
    sha256 "43f650693a4e1943a4fc9d0d0de8da0e214d4f45b9b40da2a7b8d35d4c66d8ae" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
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
    assert_match /DOSBox-X version #{version}/, shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
