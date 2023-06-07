class Fastfetch < Formula
  desc "Like neofetch, but much faster because written in C"
  homepage "https://github.com/LinusDierheimer/fastfetch"
  url "https://github.com/LinusDierheimer/fastfetch/archive/refs/tags/1.11.1.tar.gz"
  sha256 "efe0a64b6a5d54a182869ebb3c9fa7f80a04f14867dbc749fe154c59b77b9b6b"
  license "MIT"
  head "https://github.com/LinusDierheimer/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "d99551a6604c7b7fba6ebd324ed5c0a0f4ad98d0da68739707325afbfbb31e0b"
    sha256 arm64_monterey: "960823c9527d5e65584024912096ecdf8a5218f77e10489fb5afc3d505dd0daa"
    sha256 arm64_big_sur:  "1e6f136a4ccb0e84efb8e7074341d7c83fc0bcf3506e82bfce8dbfaec0f420ed"
    sha256 ventura:        "7d3e8186198b543d473201105f3c773d2726cb3937124c69ff684b2393ec6f7d"
    sha256 monterey:       "354c0e7242b8874f48910841e49c895f83cc5182642859fb1cbd11809814f834"
    sha256 big_sur:        "965c288fcc130d0271df0567dde9effc5718fc93f536baaa674b39dcf928331c"
    sha256 x86_64_linux:   "ebd0f0d813acfde32031382a86bb2a564f0d35dc0eea16f1a3c15294c1f12564"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "json-c" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
    depends_on "sqlite" => :build
    depends_on "wayland" => :build
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --logo none --hide-cursor false")
  end
end
