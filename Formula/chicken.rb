class Chicken < Formula
  desc "Compiler for the Scheme programming language"
  homepage "https://www.call-cc.org/"
  url "https://code.call-cc.org/releases/4.11.0/chicken-4.11.0.tar.gz"
  sha256 "e3dc2b8f95b6a3cd59c85b5bb6bdb2bd9cefc45b5d536a20cad74e3c63f4ad89"
  head "https://code.call-cc.org/git/chicken-core.git"

  bottle do
    revision 1
    sha256 "199e04ed0a8a62c936ed24c3c044f4c0a14c7f9e356501b936223a8ef10da6bf" => :el_capitan
    sha256 "fb5d63369b19db771c3620ae5aa584b110fb3f40df5cdd3760d9070878043e6d" => :yosemite
    sha256 "2f3a6ea745ffae4ab324c0740808d69b90e985e58946a0dfcf6bb4d44621342f" => :mavericks
  end

  def install
    ENV.deparallelize

    args = %W[
      PLATFORM=macosx
      PREFIX=#{prefix}
      C_COMPILER=#{ENV.cc}
      LIBRARIAN=ar
      POSTINSTALL_PROGRAM=install_name_tool
    ]

    # Sometimes chicken detects a 32-bit environment by mistake, causing errors,
    # see https://github.com/Homebrew/homebrew/issues/45648
    args << "ARCH=x86-64" if MacOS.prefer_64_bit?

    system "make", *args
    system "make", "install", *args
  end

  test do
    assert_equal "25", shell_output("#{bin}/csi -e '(print (* 5 5))'").strip
  end
end
