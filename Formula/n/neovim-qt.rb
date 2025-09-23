class NeovimQt < Formula
  desc "Neovim GUI, in Qt"
  homepage "https://github.com/equalsraf/neovim-qt"
  url "https://github.com/equalsraf/neovim-qt/archive/refs/tags/v0.2.19.tar.gz"
  sha256 "2c5a5de6813566aeec9449be61e1a8cd8ef85979a9e234d420f2882efcfde382"
  license "ISC"
  head "https://github.com/equalsraf/neovim-qt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "dd8bbbc56a52276068547d4cb4e84cbdd1e9f05293800e7fc60aae9cd1c96bd0"
    sha256 cellar: :any,                 arm64_ventura: "7ab5ee7ef90dc33466c2525ab9afb54cf697406025424e3cb6e8171fc1c61f7a"
    sha256 cellar: :any,                 sonoma:        "a535fb79e82a33cce34998ce1b38b104539117b89549f09621978d87521e33e7"
    sha256 cellar: :any,                 ventura:       "edbafb81758da42687579cac4f13b06b4658488bb6132b5fe20fb9012dfb9156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22f2e5fc2cf3d1f0863688b460cca53ebca3a23e9fd79d0bb769c3bbb8d6e640"
  end

  depends_on "cmake" => :build
  depends_on "msgpack"
  depends_on "neovim"
  depends_on "qt"

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
    ENV["NVIM_LISTEN_ADDRESS"] = testserver
    nvimqt_pid = spawn bin/"nvim-qt", "--nofork", "--"

    sleep 10
    sleep 5 if OS.mac? && Hardware::CPU.intel?

    system "nvim", *nvim_opts, "--remote", testfile
    system "nvim", *nvim_opts, "--remote-send", testcommand
    system "nvim", *nvim_opts, "--remote-send", ":w<CR>"
    system "nvim", "--server", testserver, "--remote-send", ":q<CR>"
    assert_equal testexpected, testfile.read.chomp
    Process.wait nvimqt_pid
  end
end
