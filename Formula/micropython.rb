class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      tag:      "v1.19.1",
      revision: "9b486340da22931cde82872f79e1c34db959548b"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23308959f468434e1173094c6e6ef2fa036dade24e45937bf3ee93097157e4c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "986b86c0c414f814e56e3333a80c711b7b905c90f65fd4d01ef97e289385be31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7c9ddec80bb88b068fb1e175f4e73b2607b97a2ef136eb63b0ab291ef0d2327"
    sha256 cellar: :any_skip_relocation, ventura:        "5ca98ed4bc48fcfd5b3d74bf3e84f4d11660912be33746a2961b3b20b3180588"
    sha256 cellar: :any_skip_relocation, monterey:       "37d6eaf666ea01b0d01d2ae98315aab88211f4c615007dce3e9a2e9fb5abbd4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "27cd7239415ae56c5e95e3309574a526644dbe4ba9dd4788f8c7423f51c663ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4f978c41832dbfdd9e81ab168e49c9ca7cd1d25b1939c7c20862856048b45ff"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" # Requires python3 executable

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
