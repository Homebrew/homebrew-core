class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.63.1.tar.gz"
  sha256 "6e124699ea20fb02c5bc402c0012543303ee75ca55ad664f96bc6cd414d7e6b3"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "05e04aa4951f18f6c3807d74a4b9795f2069da5fb1a9d63ff85dae5701ca8ba2"
    sha256               arm64_sequoia: "45b13ab7aadfc1afe69f63d4cc945e96d05802eaa411ebc9de44e8b34f08e35b"
    sha256               arm64_sonoma:  "880f2cc9e2327f706bca1bf48d6aefc560f49e863a4ac2b46218634c0b048d51"
    sha256 cellar: :any, sonoma:        "ce8f425ed61aaed00c21f6e0b84f6b739901c48163dfc52779244a1a5af56de7"
    sha256               arm64_linux:   "d7a6052dad08e890e06fdc9100fee1906931b37feeb4cc76abdba735dc71253a"
    sha256               x86_64_linux:  "167aa53d88c52b1e54d3fd4a1b90eec3b26b69235d050920bb6a2031e3380a47"
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
    depends_on "zlib-ng-compat" => :build
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
