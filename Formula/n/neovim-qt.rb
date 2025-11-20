class NeovimQt < Formula
  desc "Neovim GUI, in Qt"
  homepage "https://github.com/equalsraf/neovim-qt"
  url "https://github.com/equalsraf/neovim-qt/archive/refs/tags/v0.2.19.tar.gz"
  sha256 "2c5a5de6813566aeec9449be61e1a8cd8ef85979a9e234d420f2882efcfde382"
  license "ISC"
  head "https://github.com/equalsraf/neovim-qt.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a4ebd18a46757494d4d8914121aea77a08843626580df268d728840f28083fa2"
    sha256 cellar: :any,                 arm64_sequoia: "9203f57a83ccf4453f2c721f78102afbbbc4a21bf54d127cb6c90ce562389728"
    sha256 cellar: :any,                 arm64_sonoma:  "b74cbaf47c8f1fb3d5f0f5560b14d9974915246b2723516c8eabd0d94ccb3a16"
    sha256 cellar: :any,                 sonoma:        "ce37d682b255a3c6fbee35f0146eaf6a5022b44ba5e318b460e361fc260ebfe4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c47a0daa850d84c38744b4cad5018643b473bb94258802672ba8abdcdffa9443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0622186421cd33e3edb8e64d74c630a4632b31c613eb2e88949f440415be0f45"
  end

  depends_on "cmake" => :build
  depends_on "msgpack"
  depends_on "neovim"
  depends_on "qtbase"
  depends_on "qtsvg"

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
