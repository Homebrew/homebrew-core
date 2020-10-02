class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.6.tar.gz"
  sha256 "874450dd6f879376ce803984f7614b0edf4eb9d04117c9a88cbb3d60ce69abf0"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  livecheck do
    url :head
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "894c855137b98348bf3ff128f791c8d55024fccc06a83f1ff6bf5976627b04c5" => :catalina
    sha256 "8e30f1c88dee6590f013874ce8b5df0832092905c5206aef9114104222ce073e" => :mojave
    sha256 "07ee07cddd5cae6fabf84f9068d560b819c11a479bef8eaf3ab95b378ef4289a" => :high_sierra
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
