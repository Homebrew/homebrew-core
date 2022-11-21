class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      tag:      "v1.19.1",
      revision: "9b486340da22931cde82872f79e1c34db959548b"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f146613e2b898eb81dcdaa3b78fe9214ad7c733e7025e1a570af223fad1db52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc5514807c9010a80d3224606dfc0cfe9c6b8c135a14093b85ce348b2a8bbb82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ba97c0bdedad351506ca6247a24c3bb9e60c42b4b4a2a940b19a969c3cc9cd4"
    sha256 cellar: :any_skip_relocation, ventura:        "03c09b134daa14c2bb0601ee6496d237160c31238f2ed2cfe7ef9dd5e41dfed1"
    sha256 cellar: :any_skip_relocation, monterey:       "f0e87718ca44c30f75514b61afd66e8e1c521402487c99dcc2460b3ae670f10e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed948a56f6d4bc32ecbe528085bc052b4fdc150311efe7c8058edb7312b29940"
    sha256 cellar: :any_skip_relocation, catalina:       "3519c3b72905df1d1e6e1a966c7065e80c1ead3cebb3da50dbfd37115488c8e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10e202b63ee0424cd5efd86694d048aa99ce7d264c2e96dc883d679fd32bac94"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" # Requires python3 executable

  uses_from_macos "libffi", since: :catalina # Requires libffi v3 closure API

  def install
    # Build mpy-cross before building the rest of micropython. Build process expects executable at
    # path buildpath/"mpy-cross/mpy-cross", so build it and leave it here for now, install later.
    cd "mpy-cross" do
      system "make"
    end

    cd "ports/unix" do
      system "make", "axtls"
      system "make", "install", "PREFIX=#{prefix}"
    end

    bin.install "mpy-cross/mpy-cross"
  end

  test do
    lib_version = "6" if OS.linux?

    # Test the FFI module
    (testpath/"ffi-hello.py").write <<~EOS
      import ffi

      libc = ffi.open("#{shared_library("libc", lib_version)}")
      printf = libc.func("v", "printf", "s")
      printf("Hello!\\n")
    EOS

    system bin/"mpy-cross", "ffi-hello.py"
    system bin/"micropython", "ffi-hello.py"
  end
end
