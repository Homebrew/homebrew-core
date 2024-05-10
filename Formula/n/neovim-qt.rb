class NeovimQt < Formula
  desc "Neovim GUI, in Qt"
  homepage "https://github.com/equalsraf/neovim-qt"
  url "https://github.com/equalsraf/neovim-qt/archive/refs/tags/v0.2.18.tar.gz"
  sha256 "b1e1e019946ecb106b3aea8e35fc6e367d2efce44ca1c1599a2ccdfb35a28635"
  license "ISC"
  head "https://github.com/equalsraf/neovim-qt.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "cbc794e2861dfc0445333cd7c0015d486a2bc207fdc30c29093c3f798cd4722e"
    sha256 cellar: :any,                 arm64_ventura:  "e53af8f8ce0d65b0b5ea14544fe07be12e5b560a07f045479c8a9db96be46fa9"
    sha256 cellar: :any,                 arm64_monterey: "59268e9d0fce3668e5f97f820c3b3389f371b31cb61a7afd5fb5c8bfe6bf80d6"
    sha256 cellar: :any,                 sonoma:         "8ec8250d0dcacab51744c6c96c69dba8a5a7d076f37caebed58893d2961fd098"
    sha256 cellar: :any,                 ventura:        "f2faacba3619337ebe82f43d0183bededa813ac608ffde74a5b6db7bfe578e71"
    sha256 cellar: :any,                 monterey:       "e7c53a22b12dc61f48db137534e077965917f548b337f9b6ad0bf6ad51b44ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c72d8cf5d5aca2b06de38325c2236688aded8c62ccfdc8e8c4c4a8e80abedfb9"
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

    testcommand = ":s/Vim/Neovim/g<CR>"
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
    system "nvim", "--server", testserver, "--remote-send", ":q<CR>"
    assert_equal testexpected, testfile.read.chomp
    Process.wait nvimqt_pid
  end
end
