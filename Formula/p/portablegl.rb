class Portablegl < Formula
  desc "Implementation of OpenGL 3.x-ish in clean C"
  homepage "https://github.com/rswinkle/PortableGL"
  url "https://github.com/rswinkle/PortableGL.git",
      tag:      "0.100.0",
      revision: "63a55db75ab07619797a93ff9bf3909355d27950"
  license "MIT"
  head "https://github.com/rswinkle/PortableGL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "93cc376fab3fc5dbc505e3bce5dea8056a50e37880282a63433498410cac015a"
  end

  depends_on "sdl2" => :test

  def install
    include.install "portablegl.h"
    (pkgshare/"tests").install %w[glcommon media testing]
  end

  test do
    # Tests require PNG image outputs to be pixel-identical.
    # Such exactness may be broken by -march=native.
    ENV.remove_from_cflags "-march=native"

    cp_r Dir["#{pkgshare}/tests/*"], testpath
    cd "testing" do
      system "make", "run_tests"
      assert_match(/All \d+ tests passed/, shell_output("./run_tests"))
    end
  end
end
