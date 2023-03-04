class Portablegl < Formula
  desc "Implementation of OpenGL 3.x-ish in clean C"
  homepage "https://github.com/rswinkle/PortableGL"
  url "https://github.com/rswinkle/PortableGL.git",
    tag:      "0.97.1",
    revision: "24f8840b800f247c328860c578c19b0535be6d58"
  license "MIT"
  head "https://github.com/rswinkle/PortableGL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5072b5c557a56c16b3db6a916074c0c4933e925681c80a88bb78b9fbe6e7c307"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5072b5c557a56c16b3db6a916074c0c4933e925681c80a88bb78b9fbe6e7c307"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5072b5c557a56c16b3db6a916074c0c4933e925681c80a88bb78b9fbe6e7c307"
    sha256 cellar: :any_skip_relocation, ventura:        "a74c17ac74f36af4038cef1c4770c198fe2fb3a5e92988741ecb7b9b05598c87"
    sha256 cellar: :any_skip_relocation, monterey:       "a74c17ac74f36af4038cef1c4770c198fe2fb3a5e92988741ecb7b9b05598c87"
    sha256 cellar: :any_skip_relocation, big_sur:        "a74c17ac74f36af4038cef1c4770c198fe2fb3a5e92988741ecb7b9b05598c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5072b5c557a56c16b3db6a916074c0c4933e925681c80a88bb78b9fbe6e7c307"
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
