class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://orbiton.zip/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.65.10.tar.gz"
  sha256 "602be9292fb730ad9142dd9d8be57c6b966105418f5904a62c34190028e3c637"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b4574ace28f40243655ba66d383c1e0ed0fc1dd93b1035a06dd36684b7a2527"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9d966d818cc4d70554ee21d857540b7d0521a8e73ff96414a55bc13e43688fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d779a8cda309cddcf067859fb6ee97b60124a755b979709df599297cd41b9bc0"
    sha256 cellar: :any_skip_relocation, sonoma:         "28ce0db3327cc87194fe8bf1d3d9a0e21bdc3c2abf7b40fcf5277be8c26fd3c2"
    sha256 cellar: :any_skip_relocation, ventura:        "fd4b87ee097188f49a9a73a7c8fed07dfb29442f0bf0c589b49aae98e763253c"
    sha256 cellar: :any_skip_relocation, monterey:       "65d0d703a4793ead80452a900107d3e66972ebc5d4e6509d6c3103a13b20fd77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa5183e7337d2ad731151d02f63884a8b076e37326a17c96f0804a04710ec971"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "xorg-server" => :test
    depends_on "xclip"
  end

  def install
    system "make", "install", "symlinks", "license", "DESTDIR=", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    (testpath/"hello.txt").write "hello\n"
    copy_command = "#{bin}/o --copy #{testpath}/hello.txt"
    paste_command = "#{bin}/o --paste #{testpath}/hello2.txt"

    if OS.linux?
      system "xvfb-run", "sh", "-c", "#{copy_command} && #{paste_command}"
    else
      system copy_command
      system paste_command
    end

    assert_equal (testpath/"hello.txt").read, (testpath/"hello2.txt").read
  end
end
