class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.35.0.tar.gz"
  sha256 "e066d84f9ca176e24f162ce99dab7fac5238b5e8c94ab4aaff5850b6cc5c6ead"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "728dd5219765aa2117685c304d9474d05b3fe28821d22db6218daf0732c0f96e"
    sha256 arm64_sonoma:  "33c781637a70e827b87cf07b3f099e0517fd8007972f9d79a6e1bec0512f4fbe"
    sha256 arm64_ventura: "9654aad86bd49a8c73493956992674bab0e1b349e02715780d234828d8e7783f"
    sha256 sonoma:        "4a76279c5d9bd3f9650f34375f6b0e2ae2d6be57748293f2d56aabd32a78b1dc"
    sha256 ventura:       "35364cc046e1a6c8295cb8c0e02082c099f21da80eea603df219f6f5dfef37d5"
    sha256 x86_64_linux:  "37f95ee4219591a77c8840d0da99aebfe1fd85192eb8f4efdf3cb231f9af6182"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "sqlite" => :build
  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "ddcutil" => :build
    depends_on "elfutils" => :build
    depends_on "libdrm" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "linux-headers@5.15" => :build
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
    depends_on "wayland" => :build
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DDBUILD_FLASHFETCH=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end
