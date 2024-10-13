class Libvidstab < Formula
  desc "Transcode video stabilization plugin"
  homepage "http://public.hronopik.de/vid.stab/"
  url "https://github.com/georgmartius/vid.stab/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "9001b6df73933555e56deac19a0f225aae152abbc0e97dc70034814a1943f3d4"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f76b62fb9580b75861cc5a6d639500d095823d32bef7aa6f636fee2d87b724e9"
    sha256 cellar: :any,                 arm64_sonoma:   "f006d60e59a43562474571f2a7e2be72273cc9bd7b2df04d0c21da861ebfcab8"
    sha256 cellar: :any,                 arm64_ventura:  "25efabe3bf9a85b25065758c1ea62ef096bf2e334ce073450ef4478f7e469b38"
    sha256 cellar: :any,                 arm64_monterey: "0bff0aa6aba039cc22d6a65fbfd46f67c35ecc6db3baca439b9b1e45c3710002"
    sha256 cellar: :any,                 arm64_big_sur:  "bca6a787bd17369819451093009d298fc8a4104be1d9bd25bd9606263d097784"
    sha256 cellar: :any,                 sonoma:         "4263aef306ed5a576474d9101d8a75afc7c8e39f68a783940a81ae9fb772fe67"
    sha256 cellar: :any,                 ventura:        "40cc585d8dfe08ddb7938667997fac65cd96261f9699c4d7a1705e30267cdb61"
    sha256 cellar: :any,                 monterey:       "8caa0dce4af772a443f814f51960227e769428025f734a9a82085fc8ee499ef9"
    sha256 cellar: :any,                 big_sur:        "2b7d9891009c53a925e971b600bad2a43e5bcca062119b9080e1c5b59e2e25b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d87451266aa81a807919bb25dec5cb85e2e79eca8fa768dba8c7b74f06e11be9"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DUSE_OMP=OFF", *std_cmake_args
    system "make", "install"
  end
end
