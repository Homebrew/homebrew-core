class Mpegdemux < Formula
  desc "MPEG1/2 system stream demultiplexer"
  homepage "http://www.hampa.ch/mpegdemux/"
  url "http://www.hampa.ch/mpegdemux/mpegdemux-0.1.4.tar.gz"
  sha256 "0067c31398ed08d3a4f62713bbcc6e4a83591290a599c66cdd8f5a3e4c410419"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?mpegdemux[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cdc12b4dbb683faf6d5778773fe6655c47b8a1b8639943e0fca57a50afe967a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce2c6346e596ad75dbf869133e777b5ae0297172c93007ec0d68bf57d417faff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b69d0d03885830c30bc529606bf3f7c95181512714bca1a12e4e8aaa4a83b1cc"
    sha256 cellar: :any_skip_relocation, ventura:        "106ffa6aa9aeb4b844c50cb38aa312953a24a44c78a6dade8adc9947faafca46"
    sha256 cellar: :any_skip_relocation, monterey:       "e3c324812ab8418d89a93c67b13bcd088f434e762db103dcf9804b8afb687983"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e9ee9336d84bb82b1ee8f5b415b534ea7a8b859638cedc074875c13be16e40e"
    sha256 cellar: :any_skip_relocation, catalina:       "1fd3f22495cec5d802f73def919457122829cc617e0a7ca82a91d10e0ab8001f"
    sha256 cellar: :any_skip_relocation, mojave:         "daa143e087fe5d35e5deda8dd37637b54ba908ba34d050beb0b42b3697b1f67c"
    sha256 cellar: :any_skip_relocation, high_sierra:    "af6cd127b024079f9584533b143094cbcdb97693007eaffcb6f967942d471712"
    sha256 cellar: :any_skip_relocation, sierra:         "2a1bae657b91607e47b201f2d97749def3c771911208db70c278bf4a47f4fd7e"
    sha256 cellar: :any_skip_relocation, el_capitan:     "4f00eabfededc549d4f419b6e6bf7896dbff0c95e83fda5f47067bf73294289b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d77288a69ec6dbb402a4438a41502c23db6f47ac4fbd12d21f7a00fd57121bd"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/mpegdemux", "--help"
  end
end
