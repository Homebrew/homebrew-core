class Argus < Formula
  desc "Audit Record Generation and Utilization System server"
  homepage "https://qosient.com/argus/"
  url "https://qosient.com/argus/src/argus-3.0.8.2.tar.gz"
  sha256 "ca4e3bd5b9d4a8ff7c01cc96d1bffd46dbd6321237ec94c52f8badd51032eeff"
  license "GPL-3.0"

  livecheck do
    url "https://qosient.com/argus/src/"
    regex(/href=.*?argus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1b3fe3a7c3dd11ee63dbca00091b02d68f821087efb4343ce4136137c36295e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3b0421c50d060c2f6812a9b10ee5121336f80306a96271819737903ec98574c"
    sha256 cellar: :any_skip_relocation, monterey:       "8482631be1b4bd57043075c0dc9d05f54c6188eab3119f91a88c239f59eda4ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "c33edf660a14aa03704fe3efda1fb1282b70b127fe881a2402cfa0360a9ea86d"
    sha256 cellar: :any_skip_relocation, catalina:       "8deffdef21a05cf61e3b134532439173966ec8748f1988c4048c3173d6788d2e"
    sha256 cellar: :any_skip_relocation, mojave:         "83ea7bc0f0103ba900dad6856762aae355f726c0bb9f089cc5434c30dacce1fb"
    sha256 cellar: :any_skip_relocation, high_sierra:    "faf6ef808e9ff867eed42586ae6c27f84b66933559e9960fb48853b67325fb20"
    sha256 cellar: :any_skip_relocation, sierra:         "42487c51fa731752e10da402b5fac0f973ee090eaad19f8f4fd52fc5317c9cfb"
    sha256 cellar: :any_skip_relocation, el_capitan:     "ea46f2010610e46c120e2df100d61e01c21ee58627e105273c0e0a76437150e1"
    sha256 cellar: :any_skip_relocation, yosemite:       "b4d359943e8404d7c6a340c36bbc4d42e14a56cd80e17a997114fdc6f76552d8"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Pages", shell_output("#{bin}/argus-vmstat")
  end
end
