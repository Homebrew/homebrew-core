class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/v1.3.14.tar.gz"
  sha256 "e405b9716ea194b851b7d341f670e417ec6a319daec74d3e7bf591b71cbbac1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc89bbb7fcb608885a7aae6578e54fa728f8cba9ca85d921f58234e9b9b66d61" => :mojave
    sha256 "72d6656003d3b9c2965ef4873b849a104d5d475c8ca38194e0dd86aef5103c04" => :high_sierra
    sha256 "afe11e0c4f0235cdf8151f36cf26a7ec15f188323a70d6184f0a89bd5af08686" => :sierra
  end

  def install
    system "make"
    system "make", "install", "INSTALL_PREFIX=#{prefix}"
    system "make", "testlib", "INSTALL_PREFIX=#{prefix}"
    pkgshare.install "wrapper/testlib"
    pkgshare.install "python/test/resource/yuv/src01_hrc00_576x324.yuv"
  end

  test do
    yuv = "#{pkgshare}/src01_hrc00_576x324.yuv"
    pkl = "#{share}/model/vmaf_v0.6.1.pkl"
    output = shell_output("#{pkgshare}/testlib yuv420p 576 324 #{yuv} #{yuv} #{pkl}")
    assert_match "VMAF score = ", output
  end
end
