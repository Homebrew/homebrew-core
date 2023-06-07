class AptDater < Formula
  desc "Manage package updates on remote hosts using SSH"
  homepage "https://github.com/DE-IBH/apt-dater"
  url "https://github.com/DE-IBH/apt-dater/archive/v1.0.4.tar.gz"
  sha256 "a4bd5f70a199b844a34a3b4c4677ea56780c055db7c557ff5bd8f2772378a4d6"
  license "GPL-2.0"
  revision 1
  version_scheme 1

  bottle do
    sha256 arm64_ventura:  "1e0c235813ee8af790fad21875c7a0ed0a367bdc07b268c28932e01dacbe5289"
    sha256 arm64_monterey: "2253ecce6880052d48b9f02ef422d43b7b7197218a84001935da0bec8c92ddad"
    sha256 arm64_big_sur:  "ae020a711348a85409b5fa30467b329b1e009c006029809da302e9dc89bbee40"
    sha256 ventura:        "5189385c850b95b97c41a6fae9f09825f8f812e1603c174c73cc9d86d0954ece"
    sha256 monterey:       "19f6c2ffd1f4257b99c1b181061c5d0c8f1f56f6dfa638903ec5c8e6444b9e5f"
    sha256 big_sur:        "cf4a97e076ce5f8820c9a1dc787c5e751b350cc223d17ec0ba6007d6e8d97484"
    sha256 catalina:       "5fe58574f889c5e29bd2f4c492848281450da398cace807a33c5100b44090665"
    sha256 mojave:         "d736fdabb393e90e6895b9d5694cc0a78f592bd363483e7e935d044fd0331d41"
    sha256 high_sierra:    "f6b5f606925ac38d24ef56fc52e93c3f5a4e8f1ab2d687ebb376c78d4f91f366"
    sha256 sierra:         "66d81a3bf524ab635a34803119837ef26704011b2d362ab7f41aba0d40b54ea3"
    sha256 x86_64_linux:   "8122a7f2c4d9c1f80fddaeb7b65b333d37662a3cc8dcf2473892341879648dbb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "popt"

  uses_from_macos "libxml2"

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    # Global config overrides local config, so delete global config to prioritize the
    # config in $HOME/.config/apt-dater
    (prefix/"etc").rmtree
  end

  test do
    system "#{bin}/apt-dater", "-v"
  end
end
