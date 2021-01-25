class Megacmd < Formula
  desc "Command-line client for mega.co.nz storage service"
  homepage "https://github.com/t3rm1n4l/megacmd"
  url "https://github.com/t3rm1n4l/megacmd/archive/0.016.tar.gz"
  sha256 "def4cda692860c85529c8de9b0bdb8624a30f57d265f7e70994fc212e5da7e40"
  license "MIT"
  head "https://github.com/t3rm1n4l/megacmd.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "005012522f9d83387047d28fc1f4870b27090496d333a5ace382fd3b2b380850" => :big_sur
    sha256 "b0cc423d7d44f74416233d1890e003d8d1a92b32c4f281885e89dbda52031218" => :arm64_big_sur
    sha256 "5e3e9a0dcacef7fcac245b621b8eee36cc9dc974b46ba1006769f1dbf781b01c" => :catalina
    sha256 "a24988b1613d43a55748a6516f3d0ac15b13a533b92c201200d0c0998c4dbeb1" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    system bin/"megacmd", "--version"
  end
end
