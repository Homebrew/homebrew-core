class NeovimQt < Formula
  desc "Neovim GUI, in Qt5"
  homepage "https://github.com/equalsraf/neovim-qt"
  url "https://github.com/equalsraf/neovim-qt/archive/v0.2.17.tar.gz"
  sha256 "ac538c2e5d63572dd0543c13fafb4d428e67128ea676467fcda68965b2aacda1"
  license "ISC"
  head "https://github.com/equalsraf/neovim-qt.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "ba069626e6a18a2d6a4d7c53b1b6807ca7b47ed4fb11253c747183f13715406d"
    sha256 cellar: :any,                 arm64_monterey: "c43685139264ca10c57b80a7328340f9036c2c07fca44f507104cea67274d9e4"
    sha256 cellar: :any,                 arm64_big_sur:  "e35446a4b5b00b7b82387c523fbf229333426707a17a42c4016dfa7862681d2e"
    sha256 cellar: :any,                 ventura:        "504ec4239004f831968b089d78a28c7633210c1de1eacbce2281c0ec8e6a71df"
    sha256 cellar: :any,                 monterey:       "937fa07572c5bc168106b2bdd8d47d168ed722aa6c1ca99aa12514312abefe90"
    sha256 cellar: :any,                 big_sur:        "3cb5e4c689e23d40c5c397fb11292bd1efceb5aac51a08d42c24e2247b584996"
    sha256 cellar: :any,                 catalina:       "850cf1963c335f59b923d7085ed76d004e55ba9c058303f88886c007b8b7bff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91244720218a0ab7daeaa8a2e91e287aa1c635c33f513bf898006405b671badf"
  end

  depends_on "cmake" => :build
  depends_on "msgpack"
  depends_on "neovim"
  depends_on "qt@5"

  fails_with gcc: "5"

  # Fix finding `msgpack`
  # https://github.com/equalsraf/neovim-qt/pull/1054
  patch do
    url "https://github.com/equalsraf/neovim-qt/commit/6831b54729e0ec812a366e01fa98483114f1cf49.patch?full_index=1"
    sha256 "9bd6dc3adc1ddebed25aea00396eb4c79dd31f72d5f7e62c24d845db19ffe494"
  end

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
