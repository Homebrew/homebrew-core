class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.58.0.tar.gz"
  sha256 "95c6bb522d455ed0bd35cc0f7f3a44a70663c0e81d03fe9bfe6ffa5ea19c2b1d"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "f50745d3fded38b9c2a99d9639c66f4a7f92181190f37a06f1a5944dcce3e50f"
    sha256               arm64_sequoia: "8022d438015646682e0036e4697bf8ebd7ebac8bb19d591d098d53a7f74b81c6"
    sha256               arm64_sonoma:  "a17a5a960fbfcb6b81afa6370ba5ad3a3659c3ec73bae0cbc1b0292381e01a54"
    sha256 cellar: :any, sonoma:        "848e1fbf4748432a787910ef0a326f3bdc9570fd300da601dbcca26385a9dc78"
    sha256               arm64_linux:   "afffd1767b9d07b93600cd1515b7617e436622eb06a44c54b45aa2f4aad72318"
    sha256               x86_64_linux:  "21a72a7e1a1bed79ca380fb6f5683df77e33364ec26f0bef197332560a0a5f97"
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
