class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.27.1.tar.gz"
  sha256 "de12f8cdb52bc1f123aa9b37813f009eeb09f15cbf43b033693c2936716e2626"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "3caa661bcffbd17369a6ed988d223eeb78c2d8e34f2bf2322f150d414bf1d5c0"
    sha256 arm64_sonoma:  "40a6f78bda8615bc170aeee86127c0cd4206308119327752cc068cb7196e7af4"
    sha256 arm64_ventura: "71a6896c7000d2000c810bf467a92c927981df498c86b272d7da2fd10c7643ee"
    sha256 sonoma:        "24e3a6e0c7aefb5ae5ed5a168580a0c8012925087229073388dff4c498fdb5f3"
    sha256 ventura:       "3558b80f1bfd5fb179ba041d794c522e89a1df81655585492b3ccfe812d765fc"
    sha256 x86_64_linux:  "740c4a9a4742e0f90c33661dc377df33f651593a4a7302c03ca0472fd5cf202e"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
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
