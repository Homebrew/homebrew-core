class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v4.67.tar.gz"
  sha256 "e081a0b1da4be25dc0e09a676c472f84d57639be5bd88b7aac6af60f0ea49f12"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "648bcef4ec6117d0fc467077a56d6dc12900adeb400ce21cf79e72c0eaef2b71"
    sha256 cellar: :any,                 arm64_sonoma:  "72d63d6fe5cf11886ffc40aad972711af587a30d59afc2a9079687bde2953fca"
    sha256 cellar: :any,                 arm64_ventura: "d7561f32b7ebf62678250c010025f00d884c367c7022b73e8323eda2915ce048"
    sha256 cellar: :any,                 sonoma:        "5279169e721aab95a500c9a7ff63bf5c9cfffafda3a03fe4d2a60f56f280d2ff"
    sha256 cellar: :any,                 ventura:       "1d8d16f017ae3b95bbfa6aa0197199767f773449a17d60a2b6768161de1816c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c95192610e313b69ff43687a95ccea1fc7f922b764c2b6770cb14c9334e7f9b5"
  end

  depends_on "cmake" => :build
  depends_on "libmagic"
  depends_on "ncurses"
  depends_on "openssl@3"
  depends_on "xapian"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "expat"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux" # for libuuid
  end

  def install
    args = []
    # Workaround to use uuid from Xcode CLT
    args << "-DLIBUUID_LIBRARIES=System" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/".nmail/main.conf").write "user = test"
    output = shell_output("#{bin}/nmail --confdir #{testpath}/.nmail 2>&1", 1)
    assert_match "error: user not specified in config file", output

    assert_match version.to_s, shell_output("#{bin}/nmail --version")
  end
end
