class Portablegl < Formula
  desc "Implementation of OpenGL 3.x-ish in clean C"
  homepage "https://github.com/rswinkle/PortableGL"
  url "https://github.com/rswinkle/PortableGL.git",
    tag:      "0.94",
    revision: "ff02769271294639a3a91bef06c5a8b71fc55cfd"
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

  depends_on "python@3.11" => :test
  depends_on "sdl2" => :test

  def install
    include.install "portablegl.h"
    include.install "portablegl_unsafe.h"
    (pkgshare/"tests").install "glcommon"
    (pkgshare/"tests").install "testing"
  end

  test do
    python = Formula["python@3.11"].opt_bin/"python3.11"
    cp_r Dir["#{pkgshare}/tests/*"], testpath
    cd "testing" do
      system "make", "run_tests"
      assert_match "All tests passed", shell_output("#{python} check_tests.py")
    end
  end
end
