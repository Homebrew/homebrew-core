class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.2.0.tar.gz"
  sha256 "6d7df9be0cb3e7511243ba06e449b42286c467c050f2be010a2e3a715a82db77"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "3cf59dfaf3a058de9ca3a746969cdb64f88d0bbcca4c08496f3ccda506c49806"
    sha256 arm64_monterey: "4315645f0915160d3bbc248c5888d80fbe5014ef7c42628e4d59ed2fc00fe60c"
    sha256 ventura:        "71d0dda8643cded0fd18b50c29bf1cc1879e4ca9fefcb567e6d6f9ed40050e0d"
    sha256 monterey:       "b492c4b20bc576921ffd1c7f6e2ab7f71bfc8b99288e22e87646c357f1d50a7f"
    sha256 x86_64_linux:   "b130fdef9cc7eeca505de7db79b917530364342437c5e19d4f732ffd9a5e7de1"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "sqlite" => :build
  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "ddcutil" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pciutils" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
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
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end
