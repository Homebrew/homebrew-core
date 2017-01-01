class MpsYoutube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/mps-youtube"
  url "https://github.com/mps-youtube/mps-youtube/archive/v0.2.7.1.tar.gz"
  sha256 "917958ab02f8dace9c84974f510bd8838f905814c1a05a91fb1a38d37d19f0e8"

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
    url "https://pypi.python.org/packages/0d/f1/765c5a2e9264ab98b5515501e794962a56157e1809c96c7445d8c2cef136/pafy-0.5.2.tar.gz"
    sha256 "11e0cb83bd9e636bc4d0d6f7d7ce964f4975c6f0e037fe285ef2acedafcf7bb2"
  end

  resource "youtube_dl" do
    url "https://pypi.python.org/packages/33/53/be5fd3d2e8b4af17cce81cdece45426856868692e2b7821a957108ff302e/youtube_dl-2016.12.31.tar.gz"
    sha256 "cdba662fc6ff00b9b972da3bf4ac76d3db95841767871155a9518bfc6afb9a82"
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
