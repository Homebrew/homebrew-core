class Density < Formula
  desc "Superfast compression library"
  homepage "https://github.com/centaurean/density"
  url "https://github.com/centaurean/density/archive/density-0.14.2.tar.gz"
  sha256 "0b130ea9da3ddaad78810a621a758b47c4135d91d5b5fd22d60bbaf04bc147da"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "3c7879e53bde3927486a7ce07426c32a43057341ac351ef7af58c983b93a1be9"
    sha256 cellar: :any, arm64_big_sur:  "1a4efa81a981da64d95dd3c323e0e7ee8fd78c80f7bbcc103e301772e2efb1d7"
    sha256 cellar: :any, monterey:       "a37ef9a77b7e322d50e86cd94f10a7d1513b4f103b14a9beb03435ae49603af7"
    sha256 cellar: :any, big_sur:        "c262dbf150942de16d4054010d40622491eeba19c7f273d64a5675de9bf50024"
    sha256 cellar: :any, catalina:       "1d7dee6e22957cd5d755b11628e9a64d2233ef4abcb27e6aea15cbc9313b057e"
    sha256 cellar: :any, mojave:         "a123e229e87c6acb5e38292e35671f71e49d0cd0afbb1a315d941a49ab3ec8e4"
    sha256 cellar: :any, high_sierra:    "798b64ce99c516e735c76aea05944869124634488c82af5ba3f2930f60d83de3"
    sha256 cellar: :any, sierra:         "7740a6a2ba8aa701025c01553c57051e72b49e2f8f0774f064ca98832e1e58e9"
    sha256 cellar: :any, el_capitan:     "6853e909ed8057817becb03cbb5dbfdd3d4e2ea35348bf562e86dc51aed11a78"
  end

  resource "cputime" do
    url "https://github.com/centaurean/cputime.git",
        revision: "d435d91b872a4824fb507a02d0d1814ed3e791b0"
  end

  resource "spookyhash" do
    url "https://github.com/centaurean/spookyhash/archive/spookyhash-1.0.6.tar.gz"
    sha256 "11215a240af513e673e2d5527cd571df0b4f543f36cce50165a6da41695144c6"
  end

  def install
    (buildpath/"benchmark/libs/cputime").install resource("cputime")
    (buildpath/"benchmark/libs/spookyhash").install resource("spookyhash")
    system "make"
    include.install "src/density_api.h"
    pkgshare.install "build/benchmark"
    lib.install "build/libdensity.a"
    lib.install "build/libdensity.dylib"
  end

  test do
    system pkgshare/"benchmark", "-f"
  end
end
