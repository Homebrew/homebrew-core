class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.40.4.tar.gz"
  sha256 "cf24ffaf4729c6878b1d3a758a208905952d8b25c056bac27eb76af00ebbdb43"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "99dc9101c8c3fdbd19b0fe2a998012d0190f5840ce07bb2c5f84ab2ecd5e57d8"
    sha256 arm64_sonoma:  "16b90259c09509a2e3815b83e4f778602eb78896cecec1a59654c1912d82e46a"
    sha256 arm64_ventura: "c699bc2493eaa13b933c745c318ec425a6e9cb86b48bcbed4bdb2d5809e1a001"
    sha256 sonoma:        "4fbf3cd9f42d35552ce6a6b906c1ff7c768d5ffddc7fff895c658908bbc0dee6"
    sha256 ventura:       "37725b2acfca1f3edb3a5d48ac8ee1dac0ecd91a63974ef2648717dd0970e649"
    sha256 arm64_linux:   "7bdb8d6edbc947a6c792b7a9de875c31c4ebe54197e04a6ea7c7dc076eaa0e70"
    sha256 x86_64_linux:  "50d15d9c03b71fb843252d416150ec6447847e7a448b20418665bd68797f3f52"
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
