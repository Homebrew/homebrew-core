class Orbiton < Formula
  desc "Fast and configuration-free text editor and IDE limited by VT100"
  homepage "https://orbiton.zip/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.64.3.tar.gz"
  sha256 "f3ebdcdc7cb3502705ceda208510da1a43e65b5e0cb33e57b86564667b48303f"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  depends_on "go" => :build

  on_linux do
    depends_on "xorg-server" => :test
    depends_on "xclip" => :test
  end

  def install
    system "make", "install", "symlinks", "license", "DESTDIR=", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    (testpath/"hello.txt").write "hello\n"
    if OS.linux?
      system "xvfb-run", "#{bin}/o", "--copy", "#{testpath}/hello.txt"
      system "xvfb-run", "#{bin}/o", "--paste", "#{testpath}/hello2.txt"
    else
      system "#{bin}/o", "--copy", "#{testpath}/hello.txt"
      system "#{bin}/o", "--paste", "#{testpath}/hello2.txt"
    end
    assert_equal (testpath/"hello.txt").read, (testpath/"hello2.txt").read
  end

end
