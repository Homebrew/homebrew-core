class Fastfetch < Formula
  desc "Like neofetch, but much faster because written in C"
  homepage "https://github.com/LinusDierheimer/fastfetch"
  url "https://github.com/LinusDierheimer/fastfetch/archive/refs/tags/1.9.1.tar.gz"
  sha256 "0b6d31bc213282b26a7c2fc9706d41e1669a7ea8875154ba6aed1ba428c92b3d"
  license "MIT"
  head "https://github.com/LinusDierheimer/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "492a0f889cfe98d547753bc60f521d8005703c96387746da9675795697c885db"
    sha256 arm64_monterey: "20d77fc50ff649de7ab93c515e9b9a0783602036e8e6a714a4805091202fa363"
    sha256 arm64_big_sur:  "60b436b31c75a3b3764002b09d79dbccfad09748b85b904adfedfe563dd42609"
    sha256 ventura:        "ce560721f07d5ba421cd6dc72026dd780fbe61874b5f6d0453dabc2426797c5b"
    sha256 monterey:       "e11fcb4e06ae1ad56fecfb40544bf2885ffb64ae1eb1cd6a103b607a02555ca6"
    sha256 big_sur:        "ce1d6c419ccbe1c2b4bd7d0c15117c3daacec26ebb023043fb0662fc4c2ac8e2"
    sha256 x86_64_linux:   "cdcbd3c37cf2362deb1d2bc18299f7dd80146d52fc118a4b53118f272b01b759"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "zlib" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --logo none --hide-cursor false")
  end
end
