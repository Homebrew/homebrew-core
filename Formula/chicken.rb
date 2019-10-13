class Chicken < Formula
  desc "Compiler for the Scheme programming language"
  homepage "https://www.call-cc.org/"
  url "https://code.call-cc.org/releases/5.1.0/chicken-5.1.0.tar.gz"
  sha256 "5c1101a8d8faabfd500ad69101e0c7c8bd826c68970f89c270640470e7b84b4b"
  head "https://code.call-cc.org/git/chicken-core.git"

  bottle do
    sha256 "de1ec14d117a991683d9d8dfff264eb88368f3607f412528fcbc10df5cf76f43" => :catalina
    sha256 "f08f36b85d0a45fae786647581714722d8aaff881ce57f0504548fe1b7c76a5b" => :mojave
    sha256 "7700eba9ea0485079f542114f81109f6951908aba573b3aafa020574614bf700" => :high_sierra
    sha256 "7c79e7ec3d377cf3cc4aacae7c997859d6d11d8e081d609d3423b4cffcb48e22" => :sierra
  end

  def install
    ENV.deparallelize

    args = %W[
      PLATFORM=macosx
      PREFIX=#{prefix}
      C_COMPILER=#{ENV.cc}
      LIBRARIAN=ar
      POSTINSTALL_PROGRAM=install_name_tool
      ARCH=x86-64
    ]

    system "make", *args
    system "make", "install", *args
  end

  test do
    assert_equal "25", shell_output("#{bin}/csi -e '(print (* 5 5))'").strip
  end
end
