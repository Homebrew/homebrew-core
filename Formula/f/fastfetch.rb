class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.55.1.tar.gz"
  sha256 "65178a21158872990f570e09ca988a7dbeed3fbc27a6d64152ffdd73a9096fbd"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "1f2bb319b4ac7d41e0ed644d9b73bfbf6120ca9a577565374edf2038f9f3bf51"
    sha256               arm64_sequoia: "6b9b4c382f1f3aa6681ccd6f2559ab4aa12a0c96cfa53ca993a83761865b0ed8"
    sha256               arm64_sonoma:  "1609867ee504c14b372a9762d6eeb86be59477ad3159264aaed2d62bd9631974"
    sha256 cellar: :any, sonoma:        "03c74982be1a0db590c70cefaa7d6327a6e8ca113c0c8ab72ad8f9cb254b03f7"
    sha256               arm64_linux:   "f82056b29d87b7211dd6f87bf526a24f8a64a6b6380b0a1e43bec4bc0fba3ba2"
    sha256               x86_64_linux:  "2284131c8dec812747ad7df037032d7919e4bcf7ef1f5882dafb4f6508168003"
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
