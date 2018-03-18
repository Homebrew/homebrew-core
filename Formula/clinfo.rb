class Clinfo < Formula
  desc "Print information about OpenCL platforms and devices"
  homepage "https://github.com/Oblomov/clinfo"
  url "https://github.com/Oblomov/clinfo/archive/2.2.18.03.15.tar.gz"
  sha256 "32e9aea9f16322193f4bd657f1f2c359d0b6ed71b300b11023aa7f3d9a19223c"

  bottle do
    cellar :any_skip_relocation
    sha256 "301063822ff72ea7885216b4172b0b5ee2fbc4ac6a28e5adf00a9b6f532f4a71" => :high_sierra
    sha256 "782a4194425daa821c116f21641d0de02a7af6d58f978fa0d6d94296f3b11fc8" => :sierra
    sha256 "16f633430d1c10d5c07dc6b24577263e2b7b08a27435a1c8446bb8aca99a352c" => :el_capitan
  end

  def install
    system "make", "MANDIR=#{man}", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match /Device Type +CPU/, shell_output(bin/"clinfo")
  end
end
