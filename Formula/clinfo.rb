class Clinfo < Formula
  desc "Print information about OpenCL platforms and devices"
  homepage "https://github.com/Oblomov/clinfo"
  url "https://github.com/Oblomov/clinfo/archive/2.2.18.03.15.tar.gz"
  sha256 "32e9aea9f16322193f4bd657f1f2c359d0b6ed71b300b11023aa7f3d9a19223c"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa9fe48536bd370df3b6c3daf419c66148208f49ccf95b1e60f4e42478104d76" => :high_sierra
    sha256 "16458d147e4c5fe8208ffe5a9c6493a16cf060f627db164ccf5f9b8e80d10f40" => :sierra
    sha256 "86c955ecc79186d73a9d37f1d94f481d6a27a9c5d3c445c5dd9f2b877e87e557" => :el_capitan
  end

  def install
    system "make", "MANDIR=#{man}", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match /Device Type +CPU/, shell_output(bin/"clinfo")
  end
end
