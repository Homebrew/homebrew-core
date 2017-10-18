class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      :tag => "v1.9.2",
      :revision => "1f78e7a43130acfa4bedf16c1007a1b0f37c75c3"

  bottle do
    cellar :any
    sha256 "d16a53faf668461116e45bbdf13ab5088da593796740ecaa750640f37fd0cdf2" => :high_sierra
    sha256 "25cd2023b375d3068ab6089b1650b2add72fa90cd404751999b07493065db1b5" => :sierra
    sha256 "ca1125dcd670566e2717882049a09317fff47ca6fea3c9a832f3f5fd75919fba" => :el_capitan
    sha256 "9e2fd90b2938fc9003a15e67d2fe67c5de31806aaf05e048de21c5ce86dce98c" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libffi" # Requires libffi v3 closure API; macOS version is too old

  def install
    cd "unix" do
      system "make", "axtls"
      system "make", "install", "PREFIX=#{prefix}", "V=1"
    end
  end

  test do
    # Test the FFI module
    (testpath/"ffi-hello.py").write <<~EOS
      import ffi

      libc = ffi.open("libc.dylib")
      printf = libc.func("v", "printf", "s")
      printf("Hello!\\n")
    EOS

    system bin/"micropython", "ffi-hello.py"
  end
end
