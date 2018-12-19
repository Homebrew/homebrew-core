class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/v1.3.11.tar.gz"
  sha256 "cb0dcc2c6c8034808a62e9da07622512d5bfde0fe05073dd04428fe6de2988e9"

  bottle do
    cellar :any_skip_relocation
    sha256 "492a8d4393833fc9984ee8486bdc62484682f1f236a65d6dfb537e8c6d1a00a5" => :mojave
    sha256 "fdd93654b86a81af47cc943d446ca122b547b33bb7c96f8211803508928f449d" => :high_sierra
    sha256 "9a2f816b9c15a3825701de6744de8a5ec76370eedcb25d51c125b4f80d888679" => :sierra
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
