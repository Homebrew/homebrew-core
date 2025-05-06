class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.42.0.tar.gz"
  sha256 "9f94fdbe0642b2402517bba2fff4dd31099649d4e066f4c39b5b728cc3627f01"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "5e2bc4f93fa84301175d336447f4af1b8ff38529d54920caa90fe1c2bb552395"
    sha256 arm64_sonoma:  "7e78df084924348eef0f454aa22b894e095c16cc2d0186e08fe8e1968f939d72"
    sha256 arm64_ventura: "d6c7b20fd213933c5f51131747aafb1a4e8c5b65d670276153535cc914cd65b5"
    sha256 sonoma:        "f846bfdbf44ee17bceff43d59f3c42a5c479d910622695524bfae78f98a43149"
    sha256 ventura:       "04f9cc12c1505e93e8c460122eb0a5d4ec1811949be04d58324f1cc59246f36e"
    sha256 arm64_linux:   "3ebf13bfdd14651dd88e9eec54e5329cbfd19cd71262c1511efe74d519023e11"
    sha256 x86_64_linux:  "5f0648cb1113f5123b9f730d8d813dcf997bc598ef555e9ccde1bf511154ef3f"
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
