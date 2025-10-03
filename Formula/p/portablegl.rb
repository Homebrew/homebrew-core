class Portablegl < Formula
  desc "Implementation of OpenGL 3.x-ish in clean C"
  homepage "https://github.com/rswinkle/PortableGL"
  url "https://github.com/rswinkle/PortableGL.git",
      tag:      "0.99.0",
      revision: "4af8053b31c71eb074b1f944efe8152351dfbec9"
  license "MIT"
  head "https://github.com/rswinkle/PortableGL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ee2bac44840d1db63fc11b34aa4814ef75ffb0c71fbecad705e2961b6e9c8e6b"
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
      assert_match "All tests passed", shell_output("./run_tests")
    end
  end
end
