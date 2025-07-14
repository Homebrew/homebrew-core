class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.5.15.tar.gz"
  sha256 "f11c3efc6fefe09180a397bb671c0f616e482d36fff559a22882dd6169115bbd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "ba3f70816213350c98772f6cd8b5bd26d264254e8ecb96b9351a0deeb4ca618c"
    sha256 arm64_sonoma:  "fe8e026ccd1cfdc2ddb556379ae395e86fd821bc40c25c18a84e7c0e5f873eb9"
    sha256 arm64_ventura: "786aba88aeb41bf8ef8c86caa0ce682cf17f07bc5a7f18b0adcba8df83a34acc"
    sha256 sonoma:        "509ad18547e21df547b4183264dd4fd47b549c9c5a9e1b66369d40b706290c52"
    sha256 ventura:       "98879ef62b7a4a6a679002fd1c624158bed9ebb7c0d7d8b05a9164d21b9aaab8"
    sha256 arm64_linux:   "16bfbdfcafd2d47b2f457253bfa9316b583bb0ac01e5202395b62a6d2825c5ff"
    sha256 x86_64_linux:  "cbeff7576d15f2d960f5b326d7e0235fda3f65d9f4f079160c035a81ae7324e8"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "libpq"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
