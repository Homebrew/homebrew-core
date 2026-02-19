class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.59.0.tar.gz"
  sha256 "978e2524d0dc1ff9fd8c89fb24ae5b131af18ff108da82c6d99823712557e499"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "cf19f8b537f2edfd9eef4a0c7c4f88148c8ba0ff2791bb03f76413e281d93536"
    sha256               arm64_sequoia: "b67cca15482b45bc6d8eec61d18407552515d96e830fcabd786b1c1237ae364b"
    sha256               arm64_sonoma:  "dfb6a82dbbcf13734af0db620e73735b23cc8b324a483ed59daab62a5d9de391"
    sha256 cellar: :any, sonoma:        "e60fbe6c051052f358c0c191161243ea28b18e7ab0de62ce3f51d91c75afefbd"
    sha256               arm64_linux:   "52da3472c89ffcdd5694a1c4552d7cf126c3fac3bdc11f1c7ea39d2d8c0a1971"
    sha256               x86_64_linux:  "bc947bc56057c10772fa4290ba54d7d60e92f0326bc8154f77cf7e9b03ebf85f"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "vulkan-loader" => :build
  depends_on "yyjson"

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
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
    depends_on "wayland" => :build
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DBUILD_FLASHFETCH=OFF
      -DENABLE_SYSTEM_YYJSON=ON
    ]
    if HOMEBREW_PREFIX.to_s != HOMEBREW_DEFAULT_PREFIX
      # CMake already adds default Homebrew prefixes to rpath.
      args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"
    end
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
