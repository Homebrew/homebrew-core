class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.44.0.tar.gz"
  sha256 "3fc2b6d71e38f07ccef29945937daac7825a7cf48f67658207d31a5d42a5a90b"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "37b285dfc442da1b41cce8d0d3270f0b295e7b9abee8cb08f2791e770d25e5af"
    sha256 arm64_sonoma:  "f02842b89882f5a7af30c7b5081327e0193de817ed9829d6e8c68ea86db23988"
    sha256 arm64_ventura: "a72770593c7e97ea0b6dc54a07e0a407bf243c839d65beae24564063ed226ea4"
    sha256 sonoma:        "b2dac2aa7da5bd206b68d9810e1300da6362861c5cc4e80011d20658293fa2a4"
    sha256 ventura:       "ef053ababc63a00fa6563bd245b6f9f79c38cecce5d2aa7b259bfbc20d815771"
    sha256 arm64_linux:   "7880c0d403df3548ffd21194e2fecd2b4500ce26d23204ffe0f35265af352abd"
    sha256 x86_64_linux:  "5653f32924b11aac8517cf97e3cbda037885b01388f9b25fe66bb3d109b54853"
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
