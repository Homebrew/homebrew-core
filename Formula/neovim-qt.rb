class NeovimQt < Formula
  desc "Neovim GUI, in Qt5"
  homepage "https://github.com/equalsraf/neovim-qt"
  url "https://github.com/equalsraf/neovim-qt/archive/v0.2.16.1.tar.gz"
  sha256 "971d4597b40df2756b313afe1996f07915643e8bf10efe416b64cc337e4faf2a"
  license "ISC"
  head "https://github.com/equalsraf/neovim-qt.git"

  depends_on "cmake" => :build
  depends_on "neovim-remote" => :test
  depends_on "neovim"
  depends_on "qt@5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DUSE_SYSTEM_MSGPACK=ON"
      system "make"

      if OS.mac?
        prefix.install "bin/nvim-qt.app"
        bin.install_symlink prefix/"nvim-qt.app/Contents/MacOS/nvim-qt"
      else
        bin.install "bin/nvim-qt"
      end
    end
  end

  test do
    # Same test as Formula/neovim.rb

    # testfile = testpath/"test.txt"
    # testfile.write("Hello World from Vim!!")
    # system bin/"nvim-qt", "--nofork", testfile, "--", "-i", "NONE", "-u", "NONE", "+s/Vim/Neovim/g", "+wq"
    # assert_equal "Hello World from Neovim!!", testfile.read.chomp

    # testfile = testpath/"test.txt"
    # testserver = "localhost:9999"
    # testfile.write("Hello World from Vim!!")

    testfile = testpath/"test.txt"
    # testserver = "localhost:9999"
    testserver = testpath/"nvim.sock"

    testcommand = "s/Vim/Neovim/g"
    testinput = "Hello World from Vim!!"
    testexpected = "Hello World from Neovim!!"
    testfile.write(testinput)

    nvr_opts = ["--nostart", "--servername", testserver]

    puts "#{bin}/nvim-qt --nofork -- --listen #{testserver}"
    nvimqt_pid = spawn bin/"nvim-qt", "--nofork", "--", "--listen", testserver
    sleep 2.0
    system "nvr", *nvr_opts, "--remote", testfile
    system "nvr", *nvr_opts, "-c", testcommand
    system "nvr", *nvr_opts, "-c", "w"
    assert_equal testexpected, testfile.read.chomp
    system "nvr", *nvr_opts, "-c", "call GuiClose()"
    Process.wait nvimqt_pid

    # system "nvr", "--nostart", "--servername", testserver, "--remote", testfile, "-c", testcommand, "-c", "wq"
    # system "nvr", "--servername", testserver, "-c", "call GuiClose()", "-c", "qa"

    # nvim_pid = nvim_pid = spawn "nvim", "-i", "NONE", "-u", "NONE", "--headless", "--listen", testserver
    # nvimqt_pid = spawn bin/"nvim-qt", "--server", testserver
    # sleep(1.0)
    # system "nvr", "--servername", testserver, "--remote", testfile, "-c", "s/Vim/Neovim/g", "-c", "w"
    # #system "nvr", "--servername", testserver, "-c", "call GuiClose()"
    # system "nvr", "--servername", testserver, "-c", "call rpcnotify(0, 'Gui', 'Close', v:exiting)"
    # Process.wait nvimqt_pid
    # system "nvr", "--servername", testserver, "-c", "q"
    # Process.wait nvim_pid
    # assert_equal "Hello World from Neovim!!", testfile.read.chomp
  end
end
