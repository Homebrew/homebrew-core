class MpsYoutube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/mps-youtube"
  url "https://github.com/mps-youtube/mps-youtube/archive/v0.2.7.1.tar.gz"
  sha256 "917958ab02f8dace9c84974f510bd8838f905814c1a05a91fb1a38d37d19f0e8"
  revision 1

  bottle do
    rebuild 1
    sha256 "b0c07339711e1e9732c3a9e9e62662d798a689df6e701dd5fe479fab84d85add" => :sierra
    sha256 "c8121ccd9a8b706b290c5f3c9b613ec33c651813ac4ac4d593f133f0a5481c90" => :el_capitan
    sha256 "e8e5582225df29b3ff6aaabd5c1d8c284f18d681372971a4943520b9be1572ac" => :yosemite
  end

  depends_on "python3"
  depends_on "mpv" => :recommended
  depends_on "mplayer" => :optional

  resource "pafy" do
    url "https://pypi.python.org/packages/23/74/0e32a671b445107f34fa785ea2ac3658b0e80aef5446538a6181eba7c2e7/pafy-0.5.3.1.tar.gz"
    sha256 "35e64ff495b5d62f31f65a31ac0ca6dc1ab39e1dbde4d07b1e04845a52eceda8"
  end

  resource "youtube_dl" do
    url "https://pypi.python.org/packages/5e/28/f2aeaaf0e2b5a97c8072ebea282f2318c46327a6c07e2854c16744a0e548/youtube_dl-2017.1.31.tar.gz"
    sha256 "9edabc7881d13849f8a88aca47da7612ed8675b8706b99adca3aa46cadf71c95"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    Open3.popen3("#{bin}/mpsyt", "/september,", "da 1,", "q") do |_, _, stderr|
      assert_empty stderr.read, "Some warnings were raised"
    end
  end
end
