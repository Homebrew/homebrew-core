class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v5.0.4.tar.gz"
  sha256 "02bc5dd121dfe232bf023bd0f736ddb05ba55061034e73d6036e940b34995844"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "3946448d67edf5ceac584d35a3845e769ca59a59a60f7fa5e4121cd0f609b022"
    sha256 arm64_monterey: "92e0db6c5f70aa081ef3780b9097280b35dec5b83e2c1fae70b28537d187d3d7"
    sha256 arm64_big_sur:  "65a161bfcd3b8aa2d7bd118b05f0e883d8944ce5efd65d4c3346b49843dc3c96"
    sha256 ventura:        "7be8492389dc5c6f043fc32ad7c4e3314f9750612b58cdf96c05c92f7ad5cbb5"
    sha256 monterey:       "2730eaf13f9d869e291ff08aefd56e19dff2a07dc1b0be75ef88c61d2316f81b"
    sha256 big_sur:        "c4205063ea69017bf065cd0c2803a1e69710ce16898e693ee02aaacd333cc7bd"
    sha256 x86_64_linux:   "10766e5f561bc8202adde1037623626883e5ba4287b7daff66b0106903553daf"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "make", "CONFFILE=#{etc}/GeoIP.conf", "DATADIR=#{var}/GeoIP", "VERSION=#{version} (homebrew)"

    bin.install  "build/geoipupdate"
    etc.install  "build/GeoIP.conf"
    man1.install "build/geoipupdate.1"
    man5.install "build/GeoIP.conf.5"
  end

  def post_install
    (var/"GeoIP").mkpath
  end

  test do
    system "#{bin}/geoipupdate", "-V"
  end
end
