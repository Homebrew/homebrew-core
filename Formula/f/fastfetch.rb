class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.51.0.tar.gz"
  sha256 "c5274459d4bacafa2121855f47bf7d7022922c483c1eda04ca5fa25984713bc9"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "a3a46c72088cb62820c4d1522a13f3943ace9da78c46bdff30ad93a277b4c0bd"
    sha256                               arm64_sonoma:  "c9a619c6b0087f9e6f82a11cd4f82933490175cdb5b17adfa9be3cdad766169d"
    sha256                               arm64_ventura: "cdba7f6eb93b22904e8c3cd1931851aa428abc30ee3a4d90c516283a8a802c58"
    sha256 cellar: :any_skip_relocation, sonoma:        "4498e61d65a790b0d11d9a4932fdbe4deb31265bbf21e1b593ff6dc4b273b81b"
    sha256 cellar: :any_skip_relocation, ventura:       "9978f3ae6d8a785ca5082034764b532fe6169d7bffd23f1197bbaba99ad526dd"
    sha256                               arm64_linux:   "b835d4d8c78e99e3b0f3b1e43e342353d2de37514e16d0ed0afb5d0a49fb1420"
    sha256                               x86_64_linux:  "67069b8b30bf9175f996d142465fe3d2a1a0f2f4a8793af22b4e358eba16ad49"
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
