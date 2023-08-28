class Orbiton < Formula
  desc "Fast and configuration-free text editor and IDE limited by VT100"
  homepage "https://orbiton.zip/"
  url "https://github.com/xyproto/orbiton.git",
      tag:      "v2.64.1",
      revision: "d01e9de6baa386a08dd6fca6ad76047451fbfa18"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git"

  depends_on "go" => :build

  def install
    ENV["CXXFLAGS"] = "-Wl,--as-needed,--strip-all,--sort-common,-z,relro,-z,now"
    system "make", "install", "symlinks", "easteregg", "license", "DESTDIR=", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    # Test 1: Check if 'o --version' output contains "Orbiton"
    assert_match "Orbiton", shell_output("#{bin}/o --version")

    # Test 2: Check if copying and pasting a file with 'o' works
    (testpath/"hello.txt").write "hello\n"
    system "#{bin}/o", "-c", "#{testpath}/hello.txt" # copy the contents of hello.txt to the clipboard
    system "#{bin}/o", "-p", "#{testpath}/hello2.txt" # paste the contents of the clipboard to hello2.txt
    assert_equal (testpath/"hello.txt").read, (testpath/"hello2.txt").read
  end
end
