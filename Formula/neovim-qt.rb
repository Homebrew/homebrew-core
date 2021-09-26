class NeovimQt < Formula
  desc "Neovim GUI, in Qt5"
  homepage "https://github.com/equalsraf/neovim-qt"
  url "https://github.com/equalsraf/neovim-qt/archive/v0.2.16.1.tar.gz"
  sha256 "971d4597b40df2756b313afe1996f07915643e8bf10efe416b64cc337e4faf2a"
  license "ISC"
  head "https://github.com/equalsraf/neovim-qt.git", branch: "master"

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
