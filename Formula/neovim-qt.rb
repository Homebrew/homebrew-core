class NeovimQt < Formula
  desc "Neovim GUI, in Qt5"
  homepage "https://github.com/equalsraf/neovim-qt"
  url "https://github.com/equalsraf/neovim-qt/archive/v0.2.16.1.tar.gz"
  sha256 "971d4597b40df2756b313afe1996f07915643e8bf10efe416b64cc337e4faf2a"
  license "ISC"
  head "https://github.com/equalsraf/neovim-qt.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "6dcf4d452effff77aa85c4d556fb82f6cf7bf616d4bb6c937dac8c7c6fd9516a"
    sha256 cellar: :any, arm64_big_sur:  "2459483bd8c8a6d9520a729b3c7b37881908fce5da4b01755d42ac4370bf350e"
    sha256 cellar: :any, monterey:       "04550c385410779e9af1f8982a7317cfeefc95ef09f9a62fcfa66efba5a28ab7"
    sha256 cellar: :any, big_sur:        "42019f88da4ede0e143b06779a6d89c3c02c7b61e5029e97a11966ac62e8a4a8"
    sha256 cellar: :any, catalina:       "14c3958fc58680157c242535783da6b4979667630ca634983ab30700f220f455"
    sha256 cellar: :any, mojave:         "787697eae5c8c23f259fada57c9f3ea2b54c2db356f0635d5982dc2041341c81"
    sha256               x86_64_linux:   "23dada7f611b7e124eeb7ac6795028ced6da817e6286250e0dd8dc9b8d9c67bb"
  end

  depends_on "cmake" => :build
  depends_on "neovim-remote" => :test
  depends_on "neovim"
  depends_on "qt@5"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DUSE_SYSTEM_MSGPACK=ON"
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
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # Same test as Formula/neovim.rb

    testfile = testpath/"test.txt"
    testserver = testpath/"nvim.sock"

    testcommand = "s/Vim/Neovim/g"
    testinput = "Hello World from Vim!!"
    testexpected = "Hello World from Neovim!!"
    testfile.write(testinput)

    nvr_opts = ["--nostart", "--servername", testserver]

    ohai "#{bin}/nvim-qt --nofork -- --listen #{testserver}"
    nvimqt_pid = spawn bin/"nvim-qt", "--nofork", "--", "--listen", testserver
    sleep 10
    system "nvr", *nvr_opts, "--remote", testfile
    system "nvr", *nvr_opts, "-c", testcommand
    system "nvr", *nvr_opts, "-c", "w"
    assert_equal testexpected, testfile.read.chomp
    system "nvr", *nvr_opts, "-c", "call GuiClose()"
    Process.wait nvimqt_pid
  end
end
