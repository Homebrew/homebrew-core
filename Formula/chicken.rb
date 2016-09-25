class Chicken < Formula
  desc "Compiler for the Scheme programming language"
  homepage "https://www.call-cc.org/"
  url "https://code.call-cc.org/releases/4.11.0/chicken-4.11.0.tar.gz"
  sha256 "e3dc2b8f95b6a3cd59c85b5bb6bdb2bd9cefc45b5d536a20cad74e3c63f4ad89"
  head "https://code.call-cc.org/git/chicken-core.git"

  bottle do
    sha256 "ebe35d692b413a147a60666e8242f41c278ef62d435c546a7d7b63d40dc1e43f" => :sierra
    sha256 "46cf38e5f44a23d9fbbe9a833fba73297c54721387e74da4349e82997a5c657b" => :el_capitan
    sha256 "972a4c6c87fc3ea8d23312a76d650da696ebb66a2905ecf792f1e762dc21ea1e" => :yosemite
    sha256 "1521fde608c55c8fcf182a341f90c96274c7a6f5eb07ad75f437a6a3fde44ad5" => :mavericks
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
