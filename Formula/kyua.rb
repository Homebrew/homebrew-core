class Kyua < Formula
  desc "Testing framework for infrastructure software"
  homepage "https://github.com/jmmv/kyua"
  url "https://github.com/jmmv/kyua/releases/download/kyua-0.13/kyua-0.13.tar.gz"
  sha256 "db6e5d341d5cf7e49e50aa361243e19087a00ba33742b0855d2685c0b8e721d6"

  bottle do
    sha256 "4a30bfd9e0f4648db00aeaf62fb06715253cbbf8cfd3a0ee67347e682b2b295c" => :sierra
    sha256 "54e4d600f7ec3707314d53931d3b0dc2f50881318cdb2802c87248674e8ec5ff" => :el_capitan
    sha256 "2efeeacae19937d45b8ce03434e4377a9d60791bdac8ecb0b9e5eb3e248912d6" => :yosemite
    sha256 "c0eb883fe1104012ad0e2520b155bc49863ee7426af9bf280d7d012664f232cc" => :mavericks
  end

  depends_on "atf"
  depends_on "lutok"
  depends_on "pkg-config" => :build
  depends_on "lua"
  depends_on "sqlite"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    ENV.j1
    system "make", "install"
  end
end
