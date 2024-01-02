class NeovimQt < Formula
  desc "Neovim GUI, in Qt"
  homepage "https://github.com/equalsraf/neovim-qt"
  url "https://github.com/equalsraf/neovim-qt/archive/refs/tags/v0.2.18.tar.gz"
  sha256 "b1e1e019946ecb106b3aea8e35fc6e367d2efce44ca1c1599a2ccdfb35a28635"
  license "ISC"
  head "https://github.com/equalsraf/neovim-qt.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "52a15f676633a2f4d79617b4255f5045081828ffcece915774bebbb2ca756a3a"
    sha256 cellar: :any,                 arm64_ventura:  "c573a796d1ec3aa834f86b0c665a85336ff6fdbe86ce5e63f5457da3890930c5"
    sha256 cellar: :any,                 arm64_monterey: "60d508d9f4cc9ac36c61903f5173a4285cbec0f2158403c348b106d4b6a503d9"
    sha256 cellar: :any,                 sonoma:         "8384fc292fc63393dd5f71d671f8a238590719b3525aa237d2c7054ae4f222c6"
    sha256 cellar: :any,                 ventura:        "e7b4eac38d7b2abbe5e63bb3256442d0156416a7486c3eca5c4b0b520e621d6f"
    sha256 cellar: :any,                 monterey:       "8981b8f8d8a82848ebc8f398937f9261e5f3a5a2a7709cd4e5218ecc68b62eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "789a7dd256edc5a67ccb896034751a8ee61d9a3a5e58a04c920a3f85589e3472"
  end

  depends_on "cmake" => :build
  depends_on "msgpack"
  depends_on "neovim"
  depends_on "qt"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DUSE_SYSTEM_MSGPACK=ON", "-DWITH_QT=Qt6", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      prefix.install bin/"nvim-qt.app"
      bin.install_symlink prefix/"nvim-qt.app/Contents/MacOS/nvim-qt"
    end
  end

  test do
    # Disable tests in CI environment:
    #   qt.qpa.xcb: could not connect to display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # Same test as Formula/neovim.rb

    testfile = testpath/"test.txt"
    testserver = testpath/"nvim.sock"

    testcommand = ":%s/Vim/Neovim/g<CR>"
    testinput = "Hello World from Vim!!"
    testexpected = "Hello World from Neovim!!"
    testfile.write(testinput)

    nvim_opts = ["--server", testserver]

    ohai "#{bin}/nvim-qt --nofork -- --listen #{testserver}"
    nvimqt_pid = spawn bin/"nvim-qt", "--nofork", "--", "--listen", testserver
    sleep 10
    system "nvim", *nvim_opts, "--remote", testfile
    system "nvim", *nvim_opts, "--remote-send", testcommand
    system "nvim", *nvim_opts, "--remote-send", ":w<CR>"
    assert_equal testexpected, testfile.read.chomp
    system "nvim", "--server", testserver, "--remote-send", ":q<CR>"
    Process.wait nvimqt_pid
  end
end
