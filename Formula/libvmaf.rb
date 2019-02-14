class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/v1.3.13.tar.gz"
  sha256 "926ed538c7d7ae3a36064b87a34094a9d2bee20f7e51a64f8bb275f6c44a8ae3"

  bottle do
    cellar :any_skip_relocation
    sha256 "0510aafdf0857bc58d0930d879175b68f2e59f00b6471275f8702b915128eb8f" => :mojave
    sha256 "70aeff87f9552fed4f74e8ff3e5eab66cc552d79f5e679dc81219588bd47093a" => :high_sierra
    sha256 "bb58cd00f9322f038edeff95df70710115d2f45528f84324f99ef0bae1238b77" => :sierra
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
