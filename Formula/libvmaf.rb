class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/v1.3.9.tar.gz"
  sha256 "c9e4fc850f66cf959a36c9603cef26c4298eec20d6c26f9482a355c5753c092d"

  bottle do
    cellar :any_skip_relocation
    sha256 "22c854b26878ca4ce557b8c0e97e0ef35b721aeb85420aca7b2ee60683f6ee99" => :mojave
    sha256 "21616392bea5365658832fbe54a31dd64931222427929df813289d4f523cc882" => :high_sierra
    sha256 "90409c1f0c72ed32fdf2b1a33c09ee987bd0400c034084f155951ff1336ada83" => :sierra
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
