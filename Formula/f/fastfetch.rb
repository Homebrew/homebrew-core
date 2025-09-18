class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.52.0.tar.gz"
  sha256 "6199c4cacc0b411fde7ec6c66d12829459284c6cdfb4bacce7b535190d5cd94c"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "6d48654d6a8986648e5032b290e87f22a9e1367e0c3c869986b091bc81d37121"
    sha256               arm64_sequoia: "703eee08ba65d72a86a797611411c8e0c17868e3f327e133626c2a77a7503cd5"
    sha256               arm64_sonoma:  "429382c2c2bbdbca17a434639e0994b24ad0fce579c493ae079f96d99bf9d737"
    sha256               arm64_ventura: "2a7e45258bbf4219b7fb498e6059951b4636bac7ac20029abfb1fcdd9d310d5e"
    sha256 cellar: :any, sonoma:        "c5de607727d11107156a137f8a40b9d2a390d097309a99a5cdcd5ac1c7c40dc9"
    sha256 cellar: :any, ventura:       "3bb3d46cf94973cfa0805964ed82b433ae35da766027e899cf83750f6db3f2db"
    sha256               arm64_linux:   "38042ba128723c03e0e148b9aaf4e8708fc5e776bfd2be8f951e9b96bb76f9b6"
    sha256               x86_64_linux:  "da354fedb5e553000dcfb08841312211e02be09ca17c0d9cd4d3bb61e0ffb468"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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
