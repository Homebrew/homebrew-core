class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "ftp://ftp.invisible-island.net/byacc/byacc-20170709.tgz"
  sha256 "27cf801985dc6082b8732522588a7b64377dd3df841d584ba6150bc86d78d9eb"

  bottle do
    cellar :any_skip_relocation
    sha256 "327f52ed3680be5fac0ec1a1ed0f9974e3c9ff9e9b789b9488b8f5484d28d373" => :sierra
    sha256 "b1f0b4aeae53bac5aa8decd17304144abdce70000524f98aec054fa9ceab4f80" => :el_capitan
    sha256 "18390d8b25137a7a9fd34eb0e1510ba23864e94d00ead35d9dbf9a0fa47fb55c" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
