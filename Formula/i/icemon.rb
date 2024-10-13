class Icemon < Formula
  desc "Icecream GUI Monitor"
  homepage "https://github.com/icecc/icemon"
  url "https://github.com/icecc/icemon/archive/refs/tags/v3.3.tar.gz"
  sha256 "3caf14731313c99967f6e4e11ff261b061e4e3d0c7ef7565e89b12e0307814ca"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "ee2a82f839e771368531ab54f76b5b17b54fbfdbe1ce4ff77671321b5913c35a"
    sha256 cellar: :any,                 arm64_sonoma:   "17248733e176763f0279735fd42c504e3e52f0845279e41a27e3c019703a607e"
    sha256 cellar: :any,                 arm64_ventura:  "93377ed3f7d1b598aa9b2c4f0dd5df364e5612fa91d1501282a35ce598e946fe"
    sha256 cellar: :any,                 arm64_monterey: "ddd8e4ef2a9f056c9b1ea46968ce4e69b281816ef9c405514164d2ca65e4e61c"
    sha256 cellar: :any,                 arm64_big_sur:  "f6c322e1fbdd9f73d1a91dfd1e546f55b617cf9dbde7e22283a288a0b5013ec9"
    sha256 cellar: :any,                 sonoma:         "d8d8974be93462dfcde940fcbb20a85f3bc68d891de8e1c58b06e1eb90b39d12"
    sha256 cellar: :any,                 ventura:        "1ecf54b786d25c305bb35ee4133434643a6ea112cd1098513c3d6f6d9a054c04"
    sha256 cellar: :any,                 monterey:       "a1f66afcc9a18f14e87f6f3e631f1372f7b7d244b642d5f7f05da155d8710b06"
    sha256 cellar: :any,                 big_sur:        "f691df436bfddef842f8e64a3b5272b9be0d3faa902a0c8b7d6a1f940445c080"
    sha256 cellar: :any,                 catalina:       "dbbc9d249e23f8d6fcb3cdab7f8ff0a981134a4b7d3280355748d0b74a19c395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f6c890302532ee361d184142ec1153513e8d5be413c2479d2b9fc4146137b43"
  end

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build

  depends_on "icecream"
  depends_on "lzo"
  depends_on "qt@5"
  depends_on "zstd"

  on_macos do
    depends_on "libarchive"
  end

  on_linux do
    depends_on "libcap-ng"
  end

  fails_with gcc: "5"

  def install
    args = "-DECM_DIR=#{Formula["extra-cmake-modules"].opt_share}/ECM/cmake"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    if OS.mac?
      system bin/"icemon", "--version"
    else
      output = shell_output("#{bin}/icemon --version 2>&1", 134)
      assert_match "qt.qpa.xcb: could not connect to display", output
    end
  end
end
