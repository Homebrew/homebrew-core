class NeovimQt < Formula
  desc "Neovim GUI, in Qt5"
  homepage "https://github.com/equalsraf/neovim-qt"
  url "https://github.com/equalsraf/neovim-qt/archive/v0.2.17.tar.gz"
  sha256 "ac538c2e5d63572dd0543c13fafb4d428e67128ea676467fcda68965b2aacda1"
  license "ISC"
  head "https://github.com/equalsraf/neovim-qt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0dd3bbf7152c66e372c9a05c7d8bed4a18a9f33f49d0c64d417690c44f603c43"
    sha256 cellar: :any,                 arm64_big_sur:  "97cb2814f636dd4e15a7849a8554ae0ccf4b2c86bcc9bcad2c39bcc78ebb4635"
    sha256 cellar: :any,                 monterey:       "6300d0faa08177ead04cdbf432c0f8d8203ab2c18d8378d70bd30e74557fc6e9"
    sha256 cellar: :any,                 big_sur:        "2fdd572051b9ff5ce9bab83fff25b4734ac64cf744b1ea17ff45f855d5ff52c3"
    sha256 cellar: :any,                 catalina:       "b3c7ae2c552db8f7ae9ca51b857937b6e1714de0ad3d571f335a8c374252265e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b5fa763ad205d37c302785f23ff6e726da929c2bffb8404e581de4a34b546c0"
  end

  depends_on "cmake" => :build
  depends_on "neovim"
  depends_on "qt@5"

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
    assert_equal testexpected, testfile.read.chomp
    system "nvim", "--server", testserver, "--remote-send", ":q<CR>"
    Process.wait nvimqt_pid
  end
end
