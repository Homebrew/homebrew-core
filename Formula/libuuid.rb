class Libuuid < Formula
  homepage "https://sourceforge.net/projects/libuuid/"
  # tag "linuxbrew"

  url "https://downloads.sourceforge.net/project/libuuid/libuuid-1.0.3.tar.gz"
  sha256 "46af3275291091009ad7f1b899de3d0cea0252737550e7919d17237997db5644"

  bottle do
    cellar :any_skip_relocation
    sha256 "741229726c8670871dde15ceaf099998c1b616e48e64ba035e1f78e72eb37137" => :x86_64_linux
  end

  conflicts_with "util-linux", :because => "both install lib/libuuid.a"
  conflicts_with "ossp-uuid", :because => "both install lib/libuuid.a"

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end
end
