class Portablegl < Formula
  desc "Implementation of OpenGL 3.x-ish in clean C"
  homepage "https://github.com/rswinkle/PortableGL"
  url "https://github.com/rswinkle/PortableGL.git",
    tag:      "0.97.1",
    revision: "24f8840b800f247c328860c578c19b0535be6d58"
  license "MIT"
  head "https://github.com/rswinkle/PortableGL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abb0c595bf1ede018e8e0644d3aa263c9cd65af2572c16590b6214f23aa7f402"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abb0c595bf1ede018e8e0644d3aa263c9cd65af2572c16590b6214f23aa7f402"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abb0c595bf1ede018e8e0644d3aa263c9cd65af2572c16590b6214f23aa7f402"
    sha256 cellar: :any_skip_relocation, ventura:        "abb0c595bf1ede018e8e0644d3aa263c9cd65af2572c16590b6214f23aa7f402"
    sha256 cellar: :any_skip_relocation, monterey:       "abb0c595bf1ede018e8e0644d3aa263c9cd65af2572c16590b6214f23aa7f402"
    sha256 cellar: :any_skip_relocation, big_sur:        "abb0c595bf1ede018e8e0644d3aa263c9cd65af2572c16590b6214f23aa7f402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acdd41c99fd456db8443da0d8b1bd7a85da618b6f7c885749527a125729bb25d"
  end

  depends_on "sdl2" => :test

  def install
    include.install "portablegl.h"
    include.install "portablegl_unsafe.h"
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
