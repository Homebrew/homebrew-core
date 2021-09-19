class NeovimQt < Formula
  desc "Neovim GUI, in Qt5"
  homepage "https://github.com/equalsraf/neovim-qt"
  url "https://github.com/equalsraf/neovim-qt/archive/v0.2.16.1.tar.gz"
  sha256 "971d4597b40df2756b313afe1996f07915643e8bf10efe416b64cc337e4faf2a"
  head "https://github.com/equalsraf/neovim-qt.git"

  depends_on "cmake" => :build
  # depends_on "neovim-remove" => :test
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
    testfile = testpath/"test.txt"
    testfile.write("Hello World from Vim!!")
    system bin/"nvim-qt", "--nofork", testfile, "--", "-i", "NONE", "-u", "NONE", "+s/Vim/Neovim/g", "+wq"
    assert_equal "Hello World from Neovim!!", testfile.read.chomp

    # (testpath/"test.txt").write("Hello World from Vim!!")
    # testfile = testpath/"test.txt"
    # testhost = "localhost:9999"
    # testfile.write("Hello World from Vim!!")
    # nvim_pid = nvim_pid = spawn bin/"nvim", "-i", "NONE", "-u", "NONE", "--headless", "--listen", testhost
    # system bin/"nvim-qt", "--server", testhost, testfile
    # system bin/"nvr", "--servername", testhost, "--remote", testfile, "-c", "+s/Vim/Neovim/g", "-c", "q"
    # assert_equal "Hello World from Neovim!!", testfile.read.chomp
  end

end
