class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/v1.3.15.tar.gz"
  sha256 "43bbb484102c4d976da4a10d896fb9a11838c8aa809e9c017d5b3edb225b528d"

  bottle do
    cellar :any_skip_relocation
    sha256 "298df152c1e9d939df2fa6637113a77f76b2df91e77f4e9e8e190a45186c306c" => :catalina
    sha256 "1a11bb8c22c5ffbf56f2963c2cfc82dd4ff9615595d5f870dc4f005dbd323e7b" => :mojave
    sha256 "2480b6f5f5ff58acf9d1c732db8b2a04e408d082a53590bdad15d203e02aa791" => :high_sierra
    sha256 "c5b2cbf13a844a4591e2f1dbf7d20266715130802ba3b030f45e9471da994e86" => :sierra
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
