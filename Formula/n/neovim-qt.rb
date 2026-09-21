class NeovimQt < Formula
  desc "Neovim GUI, in Qt"
  homepage "https://github.com/equalsraf/neovim-qt"
  url "https://github.com/equalsraf/neovim-qt/archive/refs/tags/v0.2.20.tar.gz"
  sha256 "1ba4da6594a22c7fd950876329ca55cc483a37bfc87f586b1226eb34b8f3ce9d"
  license "ISC"
  head "https://github.com/equalsraf/neovim-qt.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b731a1253ac3839bd01b56e3232633b331c445735daa10a712cc408eab12aa4c"
    sha256 cellar: :any, arm64_tahoe:       "c33aadb50706b177c168aae918f1666a907380123e143e2f0770e3ac01dea200"
    sha256 cellar: :any, arm64_sequoia:     "abc8c56b111ad50a172845722e45e1088f0778653ff7f2daf36478b02e477ccf"
    sha256 cellar: :any, arm64_sonoma:      "0d2fe229e8fa9ea76b9582deba982bd48a1d45d358f931cba1f836d0f1dc10c2"
    sha256 cellar: :any, sonoma:            "2a888d51558faf05c462de8e51b776891d8747e2396f101033d4858528d02f3f"
    sha256 cellar: :any, arm64_linux:       "d728079186d56ebf9fd78d2e37467af515b0cd22c097e87bc75077fba5a7c630"
    sha256 cellar: :any, x86_64_linux:      "3cc883935a7370b9ea1323bb0d5b4672255257de9f6aa29bf585b1ff0ec807ed"
  end

  depends_on "cmake" => :build
  depends_on "msgpack"
  depends_on "neovim"
  depends_on "qtbase"
  depends_on "qtsvg"

  # Allow msgpack 6 or 7
  patch do
    url "https://github.com/equalsraf/neovim-qt/commit/93b62aadef9b1349579585570e49c645ddfd12ad.patch?full_index=1"
    sha256 "81d3b6941754ab0c0c4cf8d5dacbfd9f9291c95cfed541ddf0f41db87010cf7d"
    type :backport
    resolves "https://github.com/equalsraf/neovim-qt/issues/1192"
  end

  patch do
    url "https://github.com/equalsraf/neovim-qt/commit/acb4105de6ef7d7144fd84565441b97114a04453.patch?full_index=1"
    sha256 "f1a3c0d018aed3d7ab3ac8d0f175a481507a4ea9a89898c638e84a8267358a8d"
    type :backport
    resolves "https://github.com/equalsraf/neovim-qt/issues/1192"
  end

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
    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal"

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

    system "nvim", *nvim_opts, "--remote", testfile
    system "nvim", *nvim_opts, "--remote-send", testcommand
    system "nvim", *nvim_opts, "--remote-send", ":w<CR>"
    system "nvim", "--server", testserver, "--remote-send", ":q<CR>"
    assert_equal testexpected, testfile.read.chomp
    Process.wait nvimqt_pid
  end
end
