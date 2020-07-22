class Pycopy < Formula
  desc "Minimalist and memory-efficient Python implementation"
  homepage "https://github.com/pfalcon/pycopy"
  url "https://github.com/pfalcon/pycopy.git",
    tag:      "v3.2.4",
    revision: "5d4cf69eebc2291966aafcd8a12c1ec9f6f00d92"
  license "MIT"
  head "https://github.com/pfalcon/pycopy.git"

  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build

  uses_from_macos "libffi"

  def install
    system "make", "-C", "mpy-cross"
    cd "ports/unix" do
      system "make", "submodules"
      system "make"
      system "make", "install", "PREFIX=#{prefix}"
    end
  end

  test do
    assert_match "hello, world!", shell_output("#{bin}/pycopy -c 'print(\"hello, world!\")'")
  end
end
