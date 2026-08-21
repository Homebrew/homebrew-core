class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://algol68genie.nl/en/algol-68-genie/"
  url "https://algol68genie.nl/algol68g-3.13.3.tar.gz"
  sha256 "78dc53f4a712a9c8ee159b1eb7045fe4ea060c4eb2a49efb9634f83c2cb13995"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7b31cc637dde4a2fe2ae7bbf8a68cbbb228cb5dc49a3d927fcd950da07b64d49"
    sha256 arm64_sequoia: "b10efc2f9f3d0e402d4e6deea43ed40c304301bdd510bf13eda38d657fc8f4d1"
    sha256 arm64_sonoma:  "17113284f4c80df7e386009cf87e0f1ff89b92cb095a295f9ffd1555c648327f"
    sha256 sonoma:        "0a8219dbc78bff8213f83537081724c00b1a0c98a1c641a90b79f73ca823f4bd"
    sha256 arm64_linux:   "25fa5965ac616a5aaf86d099babea361e9f42749fa7e86fbece5f61787c313a2"
    sha256 x86_64_linux:  "396709f1219d571c2c66a14e6a9ecfa6bfd5df7472afe73f51f407ddc8870ce3"
  end

  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libpq"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~ALGOL
      print("Hello World")
    ALGOL

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
